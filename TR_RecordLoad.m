function Source = TR_RecordLoad(Experiment, IDs)

% In this version, TREX output x,y variables are stored in a single csv file
% under an individual plate folder
% or in a csv file containing many other outputs
% read these data as a table

% in RecordGUI user indicates a particular file. Load only that file

Record = Experiment.Groups(IDs.Group).Group.Records(IDs.Record).Record;
XFileName = fullfile(Record.Path, Record.Name);
TBL = readtable(XFileName);
Source.TBL = TBL;

