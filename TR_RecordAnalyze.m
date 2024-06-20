function Score = TR_RecordAnalyze(app, displayH)

% DistRadial = Eucledean distance from start to end
% PathLength = total path length
Group = app.Experiment.Groups(app.IDs.Group).Group;
Record = Group.Records(app.IDs.Record).Record;
Params = app.Experiment.Specs.Analysis.Parameters;

% check if data type is an N-by-2 table with just X and Y (previous)
% or a 30 column table, including time and various variables
% in this version analyze only pre-defined variables (e.g., X,Y)
% Note that TREX X,Y is in cm!
% other variables can be manually displayed, but at this point not yet
% analyzed

if isfield(Record.Data.Source, 'TBL')
    TBL = Record.Data.Source.TBL;
else
    TBL = Record.Data.Source.X;
end

sz = size(TBL);
if sz(2)==2
    T = length(TBL(:,1))/Params.FPS; % segment duration (sec)
    x = TBL(:,1)-TBL(1,1);
    y = TBL(:,2)-TBL(1,2);
else % time variable in TBL output from TREX not yet valid, calculate manually
%     T = TBL.time(end)-TBL.time(1); % segment duration (sec)
    T = length(TBL.time(:,1))/Params.FPS; % segment duration (sec)
    if ismember('X_wcentroid_cm_',TBL.Properties.VariableNames)
        x = TBL.X_wcentroid_cm_-TBL.X_wcentroid_cm_(1);
        y = TBL.Y_wcentroid_cm_-TBL.Y_wcentroid_cm_(1);
    else
        disp(Record.Name)
        x = TBL.X_wcentroid-TBL.X_wcentroid(1);
        y = TBL.Y_wcentroid-TBL.Y_wcentroid(1);
    end
end

% truncate end of record if longer than specified
if T > Params.MaxDuration % in sec
    maxID = floor(Params.MaxDuration*Params.FPS);
    x = x(1:maxID);
    y = y(1:maxID);
    T = maxID/Params.FPS;
end

% x = x*Params.mm_pix;
x = x*10*Params.TREXcm2cm; % mm
y = y*10*Params.TREXcm2cm; % mm
IND = find(~isnan(x) & ~isnan(y) & ~isinf(x) & ~isinf(y));
x = x(IND);
y = y(IND);
if Params.Window>0
    x = smooth(x,Params.Window*Params.FPS);
    y = smooth(x,Params.Window*Params.FPS);
end
Score.DistRadial = sqrt(x(end).^2 + y(end).^2);
dX0 = sqrt(x.^2 + y.^2);
Score.DistMaxRadial = max(dX0);
dx = diff(x);
dy = diff(y);
Score.DistAvgRadial = mean(dX0);
Score.PathLength = sum(sqrt(dx.^2+dy.^2));
Score.DMRperPL = Score.DistMaxRadial/Score.PathLength;
Score.PathLengthperTime = Score.PathLength/T;
