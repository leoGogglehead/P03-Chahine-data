%% initialize
clear all; close all; clc; tic;
if ispc  
  matlabRoot = 'C:\Users\jtmoyer\Documents\MATLAB\';
else
  matlabRoot = '/Users/jtmoyer/desk/MATLAB';
end
addpath(matlabRoot);
addpath(genpath(fullfile(matlabRoot, 'ieeg-matlab-1.8.3')));


%% Define which parts of the script to run
runBurstDetection = 0;  % refer to dataKey (f_xxxx_data_key.m)
runSpikeDetection = 0;
runSeizureDetection = 0;
runSpectrogram = 1;
runClustering = 0;
runPhysiology = 0;
saveToFile = 0;

study = 'chahine';
runThese = [1];

switch study
  case 'dichter'
    addpath(genpath('C:\Users\jtmoyer\Documents\MATLAB\P05-Dichter-data'));
  case 'jensen'
    addpath(genpath('C:\Users\jtmoyer\Documents\MATLAB\P04-Jensen-data')); 
  case 'pitkanen'
    addpath(genpath('C:\Users\jtmoyer\Documents\MATLAB\P01-Pitkanen-data')); 
  case 'chahine'
    addpath(genpath(fullfile(matlabRoot,'P03-Sleep-studies'))); 
end
fh = str2func(['f_' study '_data_key']);
dataKey = fh();


%% Establish IEEG Sessions
% Establish IEEG Portal sessions.
for r = 1:length(runThese)
  if ~exist('session','var')
    session = IEEGSession(dataKey.portalId{runThese(r)},'jtmoyer','jtm_ieeglogin.bin');
  else
    session.openDataSet(dataKey.portalId{runThese(r)});
  end
  fprintf('Opened %s\n', session.data(r).snapName);
end


%%
fig_h = 1;
for r = 1:length(runThese)
  if runSpectrogram
    winWidth = 1; % minutes
    fig_h = f_spectrogram(session.data(r),dataKey,winWidth,fig_h);
  end
end