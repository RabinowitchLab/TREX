% analyze TREX outputs and derive behavioral measures
% in this version, just use X, Y coordinates

PlotItemsStr = '{''DistRadial'', ''DistMaxRadial'', ''DistAvgRadial'', ''PathLength'', ''DMRperPL'', ''PathLengthperTime''}';
ParamAnalysisItemsStr = '{''PlateDiam'', ''mm_pix'', ''TREXcm2cm'', ''FPS'', ''MaxDuration'', ''Window''}';
ParamDisplayItemsStr = '{''dT''}';
Components(1).Name = 'PlotDropDown';
Components(1).Properties = {'Visible', 'Items', 'Value'};
Components(1).Values = {'1', PlotItemsStr,'''DistRadial'''};
Components(2).Name = 'OutputButton1';
Components(2).Properties = {'Visible','Text'};
Components(2).Values = {'1','''Overlay'''};
Components(3).Name = 'ParamAnalysisDropDown';
Components(3).Properties = {'Items', 'Value'};
Components(3).Values = {ParamAnalysisItemsStr, '''PlateDiam'''};
Components(4).Name = 'ParamDisplayDropDown';
Components(4).Properties = {'Items', 'Value'};
Components(4).Values = {ParamDisplayItemsStr, '''dT'''};
Components(5).Name = 'CalculateButton1';
Components(5).Properties = {'Visible','Text'};
Components(5).Values = {'1','''mm/pix'''};

RGapp = RecordGUI('TREX', Components);

% RGapp.Specs.Name = 'TREX';
RGapp.Specs.Records.FileType = 'csv';
RGapp.Specs.Records.uiget = 'file'; % get directory ('dir') or particular file ('file')
RGapp.Specs.Functions.RecordLoad = @TR_RecordLoad;
RGapp.Specs.Functions.RecordDisplay = @TR_RecordDisplay;
RGapp.Specs.Functions.RecordAnalyze = @TR_RecordAnalyze;
RGapp.Specs.Functions.RecordPlot = @TR_RecordPlot;
RGapp.Specs.Functions.ExportData = @TR_ExportData;
RGapp.Specs.Functions.OutputButton1 = @TR_OverlayDisplay;
RGapp.Specs.Functions.CalculateButton1 = @TR_PlateDiameter;

RGapp.Specs.Display.Parameters.dT = 1; % default time in sec between displayed path points
RGapp.Specs.Display.Parameters.Ttotal = 300; % default recording duration in sec
RGapp.Specs.Analysis.Parameters.PlateDiam = 55; % default plate diameter (mm)
RGapp.Specs.Analysis.Parameters.mm_pix = 1; % default mm per pixel
RGapp.Specs.Analysis.Parameters.TREXcm2cm = 1; % conversion from TREX to actual scale
RGapp.Specs.Analysis.Parameters.FPS = 13.066666666666667; % default frames per second (calculated manually from a few examples)
RGapp.Specs.Analysis.Parameters.MaxDuration = 6000; % default maximum record duration in sec (high default)
RGapp.Specs.Analysis.Parameters.Window = 0; % smoothing (moving average) in sec (0 = no smoothing)
