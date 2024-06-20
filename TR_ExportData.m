function TR_ExportData(File, Experiment, Type)

if Experiment.NumGrps>0
    Xstr = cell(Experiment.NumGrps);
    Data = cell(Experiment.NumGrps);
    for g=1:Experiment.NumGrps
        Group = Experiment.Groups(g).Group;
        Xstr{g} = Group.Name; %sprintf('%g',g);
        Data{g} = nan(Group.NumRecs,1);
        for r=1:Group.NumRecs
            Record = Group.Records(r).Record;
            if isfield(Record.Flags,'In') && Record.Flags.In==1 || ~ isfield(Record.Flags,'In')
                scoreStr = sprintf('Record.Data.Score.%s',Type);
                score = eval(scoreStr);
                Data{g}(r) = score;
            end
        end
    end
end

[~,Name] = fileparts(File.Exp.Name);
FileName = sprintf('%s-%s-%s.txt', Name, Type, date);
[FileName, path] = uiputfile('*.txt', 'Output file', FileName);
if FileName ~= 0
    fid = fopen(fullfile(path, FileName), 'w');
    for g=1:Experiment.NumGrps
        fprintf(fid, '%s: ', Xstr{g});
        fprintf(fid, '%f ', Data{g}(~isnan(Data{g})));
        fprintf(fid, '\n');
    end
    fclose(fid);
end
