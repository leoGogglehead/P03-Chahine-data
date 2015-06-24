function dataKey = f_chahine_data_key()

  dataKey.index = num2cell(1:3,1);
  dataKey.index = cellfun(@int2str,dataKey.index,'UniformOutput',false);

  dataKey.animalId = {
    '102396_04172014'
    '114776_04262014'
    '115130_06282014'
  };

  dataKey.portalId = {
    'I030_P001_D01'
    'I030_P002_D01'
    'I030_P003_D01'
  };

  dataKey.startSystem = {  % time when the system started recording
    '20-Sep-2013 09:20:27' % note this differs from start of meaningful data
    '20-Sep-2013 09:20:27'
    '20-Sep-2013 09:20:27'
  };

  dataKey.startEEG = {  % start of meaningful data, annotated by STW
    '20-Sep-2013 09:21:12'
    '20-Sep-2013 09:21:24'
    '20-Sep-2013 09:21:31'
};

  dataKey.endEEG = {  % end of meaningful data, annotated by STW
    '03-Oct-2013 08:34:39'
    '03-Oct-2013 08:34:39'
    '03-Oct-2013 08:34:38'
};

  dataTable = table(dataKey.animalId, dataKey.portalId, ...
    dataKey.startSystem, dataKey.startEEG, ...
    dataKey.endEEG, ...
    'RowNames', dataKey.index, 'VariableNames', ...
    {'animalId','portalId','startSystem','startEEG','endEEG'});
  
  dataKey = dataTable;

end

