clear all; clc; close all;
patientFolder = '/Users/jtmoyer/Documents/MATLAB/P03-PD-Sleep-Studies/PSG/102396_04172014/rec';
outputFolder = '/Users/jtmoyer/Documents/MATLAB/P03-PD-Sleep-Studies/PSG/102396_04172014/mef';

% create input_key structure to use for reading in data
filename = '/Users/jtmoyer/Documents/MATLAB/P03-PD-Sleep-Studies/PSG/input_key.txt';
fread

field1 = 'signal';
value1 = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG',...
  'EEG','EEG','EOG','EOG','ECG','ECG','EMG','EMG','EMG','EMG','EMG',...
  'EMG','EMG','EMG','EMG','oximeter','belt','belt','nasal pressure',...
  'thermistor','body position'};
field2 = 'HPF'
value2 = 

input_key = struct(field1,value1);
% input_key = struct('signal',{'EEG','EEG','EEG','EEG','EEG','EEG','EEG',...
%   'EEG','EEG','EOG','EOG','ECG','ECG','EMG','EMG','EMG','EMG','EMG',...
%   'EMG','EMG','EMG','EMG','oximeter','belt','belt','nasal pressure',...
%   'thermistor','body position'});


% function out = fn_convertRECData(patientFolder, outputFolder)
  % Reading and converting PD sleep data data from .rec files
  % str patientFolder = patient folder, eg '...PSG/102396_04172014/rec'
  % str outputFolder = output folder, eg '...PSG/102396_04172014/mef'
  
  curGapThres = 10000;
  
  % Get all the file names
  folderInfo = dir(patientFolder);
  
  % Get .rec files, exclude .rec.xml files
  folderInfo = folderInfo(~[folderInfo.isdir]); %remove folders
  aaa = cellfun(@(x) x(end-2:end),...
      {folderInfo.name},'uniformOutput',false);
  bbb = cellfun(@(x) strcmpi(x,'rec'),aaa)
  folderInfo = folderInfo(bbb);
  
  %   % Sort by Name (probably not necessary)
  %   [~,ix] = sort({folderInfo.name});
  %   folderInfo = folderInfo(ix);  
  
  % Write MEF files
  MEFHandles = {};
  MEFChannelNames = [];
  MEFSamplingRate = [];
  dateOffset = nan;
  firstDateNum = nan;
%   figure
%   hold on
  
  for i = 1: length(folderInfo)
    curFileStr = fullfile(patientFolder,folderInfo(i).name);
%     [hdr, data] = readPersystLay(curFileStr);
    
    curSF = hdr.FileInfo.SamplingRate; 
    curBlockSize = ceil((4000)/curSF);
    
    startTime = 0;
    
%     startTime = str2num(sprintf('int64(%s)',...
%       hdr.NP_FileInfo.ECoGTimeStampAsUTC))/10; %#ok<ST2NM> In usec since 1601
%     if i == 1
%       startTime2 = startTime - int64(116444736000000000); %offset in usec since 1970. 
%       out = double(datenum(1970,1,1) + startTime2/86400000000);
%       datevc = datevec(out);
%       timeOffset = (datevc(4)*3600 +datevc(5)*60 +datevc(6))*1e6;
%       dateOffset = 946684800000000 + timeOffset;
%       firstDateNum = startTime;
%       startTime = dateOffset;
%       
%     else
%       startTime = double(dateOffset + startTime - firstDateNum);
%     end
    
%     timeVec = 1 : (hdr.FileInfo.nrSamples);
%     timeVec = startTime + (1e6*(timeVec./curSF));
    
    for iChan = 1: length(input_key)
     chanName = sprintf('%s-%s',...
      hdr.ChannelMap(iChan).channel, hdr.ChannelMap(iChan).ref);
     
      nameIdx = strcmp(chanName, MEFChannelNames);
      sfIdx = MEFSamplingRate == curSF;
      handleIdx = find(nameIdx & sfIdx,1);
      
      % Create MEF file if it does not exist.
      if isempty(handleIdx)
        h = edu.mayo.msel.mefwriter.MefWriter(...
          fullfile(outputFolder,[chanName '.mef']), ...
          curBlockSize, curSF, curGapThres); 
        handleIdx = length(MEFHandles)+1;
        MEFHandles(length(MEFHandles)+1) = h; %#ok<AGROW>
      end
      
      plot(timeVec)
      
      % Write data
      MEFHandles{iChan}.writeData(data(:,iChan), timeVec, size(data,1));

%       MEFHandles{handleIdx}.writeData(data(:,iChan), timeVec, size(data,1));
        
    end

  end
  
  % Close MEFHandles
  for i = 1:length(MEFHandles)
    MEFHandles{i}.close();
  end

% end