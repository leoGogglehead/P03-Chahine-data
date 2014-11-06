clear all; clc; close all;
% .slp file is converted to .rec EDF file in the rec/ directory
% two alternative .edf exports are included in the edf/ directory - use
%    ID_DATE not ...referenced
% epoch information is included in ...event_list.txt
% input_key.txt contains channel information for the import

curSF = 500;          % sampling frequency of data, in Hz
curGapThres = 10000;  % Gap time threshold, in usec
curBlockSize = 5000;  % suggested block size in # of samples
curConv = 1;
curBase = 1;
MEFUpscale = 1;
STEPSIZE = 100000;


%% Get all the file names
path = '/Users/jtmoyer/Documents/MATLAB/P03-PD-Sleep-Studies/PSG';
patientdir = dir(path);
j = 1;
for i = 1: length(patientdir)
  if ~strncmp(patientdir(i).name,'.',1) && patientdir(i).isdir
    ptnames{j} = patientdir(i).name;
    recnames{j} = fullfile(path,patientdir(i).name,'rec',[ptnames{j},'.rec']);
    mefnames{j} = fullfile(path,patientdir(i).name,'mef',[ptnames{j},'.mef']);
    j = j + 1;
  end
end

% convert to MEF
% import channel information from text document input_key.txt 
% create a separate mef file for each channel
% 

%% create empty MEF files, one for each channel in the .dat file
% for j = 1: length(ptnames)
%   mw1 = edu.mayo.msel.mefwriter.MefWriter(...
%     mefnames, curBlockSize, curSF, curGapThres);
%   mw1.setVoltageConversionFactor( (curConv * curBase) / MEFUpscale);
%   mw2 = edu.mayo.msel.mefwriter.MefWriter(...
%     fullfile(path,'MEF-output',[ptnames(j).name '_2.mef']), curBlockSize, curSF, curGapThres);
%   mw2.setVoltageConversionFactor( (curConv * curBase) / MEFUpscale);
%   mw3 = edu.mayo.msel.mefwriter.MefWriter(...
%     fullfile(path,'MEF-output',[ptnames(j).name '_3.mef']), curBlockSize, curSF, curGapThres);
%   mw3.setVoltageConversionFactor( (curConv * curBase) / MEFUpscale);
%   mw4 = edu.mayo.msel.mefwriter.MefWriter(...
%     fullfile(path,'MEF-output',[ptnames(j).name '_4.mef']), curBlockSize, curSF, curGapThres);
%   mw4.setVoltageConversionFactor( (curConv * curBase) / MEFUpscale);
% end        


% %% Iterate over all the files
% startOffset = 0;
% for j = 1: length(ptnames)
%   if j==1
%     startOffset = str2double(filenames(j).name(1:(end-4)));
%     startOffset = startOffset / 10;
%   end
%   
%   for i = 1: length(filenames)
%     fileID = fopen(fullfile(path,'DAT-input',ptnames(j).name,filenames(i).name));
%     m = fread(fileID, inf, 'int16');
%     fclose(fileID);
%     data = reshape(m,4,[]);
% 
%     %% Iterate over channels and write data
%       f = filenames(i).name;
%       f(end-3:end)= [];
%       tmp(i) = (str2double(f) / 10) - startOffset;
%       curTime = (str2double(f) / 10) - startOffset;  % convert to usec
%       
%       %timeVec = curTime : 1e6/curSF : (curTime + 1e6/curSF * STEPSIZE-1);
%       
%       timeVec = 1:(size(data,2));
%       timeVec = timeVec * 1e6/curSF;
%       timeVec = timeVec + curTime;
%       
% %       mw1.writeData(data(1,:), timeVec, length(data(1,:)));
% %       mw2.writeData(data(2,:), timeVec, length(data(2,:)));
% %       mw3.writeData(data(3,:), timeVec, length(data(3,:)));    
% %       mw4.writeData(data(4,:), timeVec, length(data(4,:)));
%   end
% %% Close all the MEF files
% 
% mw1.close();
% mw2.close();
% mw3.close();
% mw4.close();
% end


