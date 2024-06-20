function TR_OverlayDisplayAll(RGapp)

% External function
% Loop through all groups
% Loop through all records of a group. Set start point as (0,0)
% Plot all paths, each in a different color

IDs.Group = RGapp.IDs.Group;

fig = figure(1);
NG = RGapp.Experiment.NumGrps;
row = ceil(sqrt(NG));

colormap(jet)

D = 0;
for g=1:NG
    displayH = subplot(row,row,g);
    RGapp.IDs.Group = g;
    TR_OverlayDisplay(RGapp, displayH)
    X = get(displayH, 'XLim');
    Y = get(displayH, 'YLim');
    d = max(max(abs(X)),max(abs(Y)));
    if d>D
        D = d;
    end
end
for g=1:NG
    subplot(row,row,g);
    GStr = RGapp.Experiment.GroupList{g};
    axis square
    set(gca,'XLim', D.*[-1,1],'YLim',D.*[-1,1]);
    title(GStr);
end

RGapp.IDs.Group = IDs.Group;

set(fig,'RendererMode','manual','Renderer', 'painters');
