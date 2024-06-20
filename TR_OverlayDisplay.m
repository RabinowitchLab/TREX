function TR_OverlayDisplay(app, displayH)

% Loop through all records of a group. Set start point as (0,0)
% Plot all paths, each in a different color
% Note that TREX X,Y is in cm!

MarkerSize = 10; 

% Ttotal = Param.Ttotal; % total duration (sec)
dT = app.Experiment.Specs.Display.Parameters.dT; % interval between display points (sec)
Window = app.Experiment.Specs.Analysis.Parameters.Window;
FPS = app.Experiment.Specs.Analysis.Parameters.FPS;
Params = app.Experiment.Specs.Analysis.Parameters;

Group = app.Experiment.Groups(app.IDs.Group).Group;
NR = Group.NumRecs;

colormap(displayH,jet)
colorMap = jet(NR);
displayH.NextPlot = 'replacechildren';
displayH.Visible = 1;
for r=1:NR
    Record = Group.Records(r).Record;
    if isfield(Record.Flags,'In') && Record.Flags.In==1 || ~ isfield(Record.Flags,'In')
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
            Ttotal = TBL.time(end); % segment duration (sec)
            if ismember('X_wcentroid_cm_',TBL.Properties.VariableNames)
                x = TBL.X_wcentroid_cm_-TBL.X_wcentroid_cm_(1);
                y = TBL.Y_wcentroid_cm_-TBL.Y_wcentroid_cm_(1);
            else
                x = TBL.X_wcentroid-TBL.X_wcentroid(1);
                y = TBL.Y_wcentroid-TBL.Y_wcentroid(1);
            end
        end
        
        x = x*10*Params.TREXcm2cm; % mm
        y = y*10*Params.TREXcm2cm; % mm

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
%         NT = numel(xT);
        
        color = colorMap(r,:);
        plot(displayH,x,y,'k')
        displayH.NextPlot = 'add';
%         plot(displayH,xT,yT,'.','Color',color, 'MarkerSize', MarkerSize)
    end
end
D = max(max(abs(get(displayH,'XLim'))),max(abs(get(displayH,'YLim'))));
set(displayH,'XLim', D.*[-1,1],'YLim',D.*[-1,1]);
set(displayH, 'Color', [0.94,0.94,0.94]);
colorbar(displayH,'off')
title(displayH,sprintf('Interval = %gsec',dT));
