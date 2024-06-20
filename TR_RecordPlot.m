function TR_RecordPlot(Experiment, plotH, Type, IDs)

if Experiment.NumGrps>0
    width = 0.2;
    plotH.NextPlot = 'replacechildren';
    plotH.Visible = 1;
    Xstr = cell(Experiment.NumGrps);
    maxScore = 0;
    Data = cell(Experiment.NumGrps);
    for g=1:Experiment.NumGrps
        Group = Experiment.Groups(g).Group;
        Xstr{g} = Group.Name; %sprintf('%g',g);
        Data{g} = nan(Group.NumRecs,1);
        RandPos = (rand(Group.NumRecs,1)-0.5)*width;
        for r=1:Group.NumRecs
            Record = Group.Records(r).Record;
            if isfield(Record.Flags,'In') && Record.Flags.In==1 || ~ isfield(Record.Flags,'In')
                scoreStr = sprintf('Record.Data.Score.%s',Type);
                score = eval(scoreStr);
                Data{g}(r) = score;
                if score>maxScore
                    maxScore=score;
                end
                if g==IDs.Group && r==IDs.Record
                    clr = 'r.';
                else
                    clr = 'k.';
                end
                plot(plotH, g-0.5+RandPos(r), score, clr, 'MarkerSize', 12);
                plotH.NextPlot = 'add';
            end
        end
        Gmean = mean(Data{g}(~isnan(Data{g})));
        plot(plotH, g-0.5+[-width/2,+width/2],Gmean*[1 1], 'k', 'LineWidth', 2); 
    end
    plotH.XLim = [0,Experiment.NumGrps];
%     plotH.YLim = [0,ceil(maxScore)];
    plotH.YLim = [0,maxScore];
    plotH.XTick = 0.5:Experiment.NumGrps-0.5;
    plotH.XTickLabel = Xstr;
    plotH.YTickMode = 'auto';
    plotH.YLabel.String = sprintf('%s (mm)', Type);
end
