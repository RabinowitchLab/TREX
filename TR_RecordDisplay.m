function TR_RecordDisplay(app, displayH)

Group = app.Experiment.Groups(app.IDs.Group).Group;
Record = Group.Records(app.IDs.Record).Record;

% Ttotal = Param.Ttotal; % total duration (sec)
dT = app.Experiment.Specs.Display.Parameters.dT; % interval between display points (sec)
Window = app.Experiment.Specs.Analysis.Parameters.Window;
FPS = app.Experiment.Specs.Analysis.Parameters.FPS;

if isfield(Record.Data.Source, 'TBL')
    TBL = Record.Data.Source.TBL;
else
    TBL = Record.Data.Source.X;
end

sz = size(TBL);
if sz(2)==2
    Ttotal = length(TBL(:,1))/FPS; % segment duration (sec)
    x = TBL(:,1)-TBL(1,1);
    y = TBL(:,2)-TBL(1,2);
else
    Ttotal = TBL.time(end)-TBL.time(1); % segment duration (sec)
    if ismember('X_wcentroid_cm_',TBL.Properties.VariableNames)
        x = TBL.X_wcentroid_cm_-TBL.X_wcentroid_cm_(1);
        y = TBL.Y_wcentroid_cm_-TBL.Y_wcentroid_cm_(1);
    else
        x = TBL.X_wcentroid-TBL.X_wcentroid(1);
        y = TBL.Y_wcentroid-TBL.Y_wcentroid(1);
    end
end     
    
IND = find(isinf(x) | isinf(y));
x(IND) = nan;
y(IND) = nan;
if Window>0
    x = smooth(x,Window*FPS);
    y = smooth(x,Window*FPS);
end
n = numel(x);
dt = Ttotal/n; % interval between each frame (sec)
xT = interp1(dt:dt:Ttotal,x,dT:dT:Ttotal);
yT = interp1(dt:dt:Ttotal,y,dT:dT:Ttotal);
NT = numel(xT);

colormap(displayH,jet)
colorMap = jet(NT);
displayH.NextPlot = 'replacechildren';
displayH.Visible = 1;
for k=1:NT
    color = colorMap(k,:);
    plot(displayH,xT(k),yT(k),'.','Color',color, 'MarkerSize', 20)
    displayH.NextPlot = 'add';
end
% axis(displayH,'equal')
D = max(max(abs(x)),max(abs(y)));
set(displayH,'XLim', D.*[-1,1],'YLim',D.*[-1,1]);
colorbar(displayH,'Ticks',[0,1],'TickLabels',{'start','end'})
title(displayH,sprintf('Interval = %gsec',dT));
plot(displayH,x,y,'k');
if isfield(Record.Flags,'In') && Record.Flags.In==1 || ~ isfield(Record.Flags,'In')
    set(displayH, 'Color', [0.94,0.94,0.94]);
else
    set(displayH, 'Color', [0.8 0.8 0.8]);
end
