function params = f_chahine_params(params)

  switch params.label
    case 'sleep'              % spike-threshold
      switch params.technique
        case 'powerbands'
          params.function = @(x) (sum(abs(diff(x)))); % feature function
          params.windowLength = 2;         % sec, duration of sliding window
          params.windowDisplacement = 1;    % sec, amount to slide window
          params.blockDurMinutes = 15;            % minutes; amount of data to pull at once
          params.smoothDur = 20;   % sec; width of smoothing window
          params.minThresh = 7e4; % threshold feature must cross for detection
          params.maxThresh = params.minThresh*4;  
          params.minDur = 10;    % sec; min duration of the seizures
          params.maxDur = 120;    % sec; min duration of the seizures
          params.viewData = 1;  % look at the data while it's running?
          params.plotWidth = 1; % minutes, if plotting, how wide should the plot be?
          params.saveToDisk = 0;  % save feature calculations to disk, vs just the threshold crossings
      end
  end
end