function out = levelrerecur(rID, in, levels)

    out = cell(length(in), 1);
    
    for i= 1:length(in)
        if levels.LevelID(levels.SeriesID == in.Parent(i)) ~= rID
            %idx = levels(levels.SeriesID == in.Parent, :);
            idx = levels(levels.LevelID <= levels.LevelID(levels.SeriesID == in.Parent(i)), :);

            t1 = matpacks.iofun.levelrerecur(rID, levels(levels.SeriesID == in.Parent(i), :), idx);

        else

            t1 = levels.FullName(levels.SeriesID == in.Parent(i));

        end
        out(i) = t1;
    end
    
    if length(in) == 1;
        out = out(i);
    end
    
end