function [] = f_txt2portal(dataset, animalDir, layerName)
  %   This is a generic function that converts data from the raw binary *.eeg 
  %   format to MEF. Header information for this data is contained in the
  %   *.bni files and the data is contained in the *.eeg files.  Files are
  %   concatenated based on the time data in the .bni file, resulting in one
  %   file per channel which includes all data sessions.
  %
  %   INPUT:
  %       animalDir  = directory with one or more .eeg files for conversion
  %       dataBlockLen = amount of data to pull from .eeg at one time, in hrs
  %       gapThresh = duration of data gap for mef to call it a gap, in msec
  %       mefBlockSize = size of block for mefwriter to wrte, in sec
  %
  %   OUTPUT:
  %       MEF files are written to 'mef\' subdirectory in animalDir, ie:
  %       ...animalDir\mef\
  %
  %   USAGE:
  %       f_eeg2mef('Z:\public\DATA\Animal_Data\DichterMAD\r097\Hz2000',0.1,10000,10);
  %
   dbstop in f_txt2portal at 55

  %....... Load .txt annotations  
  txtDir = fullfile(animalDir,'');
    
  % scan in text data
  try % try using the .bni extension
    txt_name = fullfile(txtDir, [animalDir(40:end) '_event list.txt']);
    fid = fopen(txt_name);   % METADATA IN BNI FILE
    metadata = textscan(fid,'%[^:]: %[^\n]', 12);
    textscan(fid,'%*[^\n]',1);
    textdata = textscan(fid, '%*[^\t] %[^\t] %[^\t] %[^\n]\n');
    fclose(fid);
  catch err % if problem, try using the .bni_orig extension
    fprintf('Check text file exists: %s\n', txt_name);
    rethrow(err);
  end
  
  % store important metadata values
  patientID = char(metadata{1,2}(strcmp(metadata{:,1}, 'Patient Name')));
  assert(strcmp(patientID(1:15), animalDir(40:end)),'Patient name does not match: %s\n',txt_name);
  recordTime = char(metadata{1,2}(strcmp(metadata{:,1}, 'Study Date')));
  recordTime = recordTime(10:end);
  dateFormat = 'HH:MM:SS AM';
  dateOffset = datenum(recordTime, dateFormat); % in days
  
  % extract label, time, and duration values for each annotation
  % remove any labels that don't have a duration value - they are redundant
  keepInds = ~cellfun(@isempty,strtrim(textdata{3}));
  annotation = strtrim(textdata{1}(keepInds));
  times = textdata{2}(keepInds);
  times = datenum(times, 'HH:MM:SS AM') - dateOffset;
  % convert to Usec; times after midnight need to be set to the next day
  timesUsec = (times - sign(times) + 1) * 24 * 60 * 60 * 1e6;
  duration = cellfun(@strsplit,textdata{3}(:),'UniformOutput',false);
  
  allLabels = cell(1,3);
  for f = 1:size(revList,1) 
    % open and scan .rev file
    fid = fopen(revList{f,1});   
    revText = textscan(fid,'%f %*[^:]:%[^;];%*[^;];%*[^:]:%[^<]<%*[^>]>');
    fclose(fid);
    
    % open and scan associated .bni file
    try % try using the .bni extension
      bni_name = [revList{f,2} '.bni'];
      fid=fopen(bni_name);   % METADATA IN BNI FILE
      metadata=textscan(fid,'%s = %s %*[^\n]');
      fclose(fid);
    catch % if problem, try using the .bni_orig extension
      bni_name = [revList(f) '.bni_orig'];
      fid=fopen(bni_name);   % METADATA IN BNI FILE
      assert(fid > 0, 'Check BNI file exists: %s\n', rev250List(f).name);
      metadata=textscan(fid,'%s = %s %*[^\n]');
      fclose(fid);
    end
    recordDate = char(metadata{1,2}(strcmp(metadata{:,1}, 'Date')));
    recordTime = char(metadata{1,2}(strcmp(metadata{:,1}, 'Time')));
    dateNumber = datenum(sprintf('%s %s', recordDate, recordTime), dateFormat);
    startTime = (dateNumber - dateOffset) * 24 * 3600 * 1e6; % in microseconds
    
    revText{1} = revText{1}*1e6 + startTime;
    revText{2} = strtrim(revText{2});
    revText{3} = strtrim(revText{3});
    % datestr(datenum(revText{1}/1e6/3600/24)+dateOffset-1)
    for i = 1: 3
      allLabels{i} = [allLabels{i}; revText{i}];
    end
  end
  
  %....... Add annotations to portal
  eventTimes = allLabels{1};
  eventChannels = allLabels{2}; % 'L_DG', 'ch_01', 'ch_02',
  eventLabels = allLabels{3};
  
  % save unique channels and labels to a text file for reference
  uniqueLabels = unique(eventLabels);
  uniqueChannels = unique(eventChannels);
  fid = fopen(fullfile(txtDir, [animalDir(39:42) '.txt']),'w');
  fprintf(fid, 'uniqueChannels\r\n');
  fprintf(fid, '%s\r\n', uniqueChannels{:});
  fprintf(fid, '\r\nuniqueLabels\r\n');
  fprintf(fid, '%s\r\n', uniqueLabels{:});
  fclose(fid);
  
  fprintf('\nAnimal: %s\n', animalDir(39:42));
  % upload annotations to dataset
  % remove old layer and add new one
  try 
    fprintf('Removing existing layer\n');
    dataset.removeAnnLayer(layerName);
  catch 
    fprintf('No existing layer\n');
  end
  annLayer = dataset.addAnnLayer(layerName);

  % create annotations
  fprintf('Creating annotations...');
%  ann = IEEGAnnotation.createAnnotations(eventTimes, eventTimes+5*1e6, 'Event', eventLabels, dataset.channels(1));
  ann = IEEGAnnotation.createAnnotations(eventTimes, eventTimes+1*1e6, 'Event', eventLabels, dataset.channels(1));
  fprintf('done!\n');

%   for i = 1:numel(uniqueAnnotChannels)
%     tmpChan = uniqueAnnotChannels(i);
%     ann = [ann IEEGAnnotation.createAnnotations(eventTimesUSec(eventChannels==tmpChan,1), ...
%       eventTimesUSec(eventChannels==tmpChan,2),'Event', ...
%       params.label,dataset.channels(tmpChan))];
%   end

  %add annotations 5000 at a time (freezes if adding too many)
  numAnnot = numel(ann);
  startIdx = 1;
  fprintf('Adding annotations...\n');
  for i = 1:ceil(numAnnot/5000)
    fprintf('Adding %d to %d\n',startIdx,min(startIdx+5000,numAnnot));
    annLayer.add(ann(startIdx:min(startIdx+5000,numAnnot)));
    startIdx = startIdx+5000;
  end
  fprintf('done!\n');
end