data_key = function fn_P03_create_datakey()

  data_key.signal = {
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EEG'
    'EOG'
    'EOG'
    'ECG'
    'ECG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'EMG'
    'oximeter'
    'belt'
    'belt'
    'nasal pressure'
    'thermistor'
    'body position'
  };

  data_key.high_pass = {
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0.15'
    '0'
    '0.05'
    '0.05'
    '0'
    '0'
    '0'
  };

  data_key.low_pass = {
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '64'
    '128'
    '128'
    '128'
    '128'
    '128'
    '128'
    '128'
    '128'
    '128'
    'NaN'
    '15'
    '15'
    'NaN'
    'NaN'
    'NaN'
  };

  data_key.notch_filter = {
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'On'
    'On'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'Off'
    'On'
    'On'
    'Off'
    'Off'
    'Off'
  };

  data_key.location = {
    'F3'
    'F4'
    'C3'
    'C4'
    'O1'
    'O2'
    'T4'
    'M1'
    'M2'
    'E1'
    'E2'
    'ECG 1'
    'ECG 2'
    'chin1'
    'chin2'
    'chin3'
    'right arm'
    'left arm'
    'right leg' 
    'left leg'
    'right foot'
    'left foot'
    'oximeter'
    'thoracic'
    'abdomen'
    'nasal pressure'
    'thermistor'
    'body position'
  };
  data_key.FS = {
    256
    256
    256
    256
    256
    256
    256
    256
    256
    256
    256
    128
    128
    256
    256
    256
    256
    256
    256
    256
    256
    256
    1
    32
    32
    32
    32
    4    
  };

  data_key.range = {
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 uV'
    '10 mV'
    '10 mV'
    '500 uV'
    '500 uV'
    '500 uV'
    '500 mV'
    '500 mV'
    '500 mV'
    '500 mV'
    '500 mV'
    '500 mV'
    'direct'
    '10 mV'
    '10 mV'
    'fixed'
    'fixed'
    '500 mV'
  };

  data_key.channel = {
    '17'
    '18'
    '5'
    '6'
    '7'
    '8'
    '20'
    '9'
    '10'
    '11'
    '12'
    '13'
    '14'
    '15'
    '16'
    '19'
    '22'
    '21'
    '2'
    '3'
    '24'
    '23'
    'Oximeter'
    '31'
    '32'
    'Ext pressure'
    '29'
    '1'
  };

  save('data_key.mat', 'data_key');

return data_key