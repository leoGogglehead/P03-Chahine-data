function fig_h = f_spectrogram(snapshot,dataKey,winWidth,fig_h)
%   dbstop in f_spectrogram at 23

  fs = snapshot.channels(2).sampleRate;
  numSamples = snapshot.channels(2).getNrSamples();
  blockSize = winWidth * 60 * fs; % convert from minutes to samples  
  numBlocks = ceil(numSamples/blockSize);
  
  for b = 1: numBlocks
    curPt = 1+(b-1)*blockSize;
    endPt = min([b*blockSize numSamples]);
    blockOffset = (b-1) * blockSize / fs;
    
    data = snapshot.getvalues(curPt:endPt,2:7);
    time = (curPt:endPt)/fs/60 + (b-1)*blockSize/fs/60; % in minutes
%     A = rand(1,length(time))*0.5 - 1;
%     data = sin(50*2*pi*time) + A;
    
    figure(fig_h);
%     spectrogram(data,256,128,1:32,fs,'yaxis');;
    for c = 1: 6
      subplot(6,1,c); 
      spectrogram(data(:,c),256,128,1:32,fs,'yaxis');
      title(snapshot.channels(2).label);
    end
    pause;
  end
  fig_h = fig_h + 1;
end