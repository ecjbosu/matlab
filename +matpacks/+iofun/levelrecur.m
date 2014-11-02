function out = levelrecur(in, ID)

    idx = ismember(in.Parent , ID);
    loc = find(idx);
    out = [];
    i = 1;
    
    if any(idx)
            
        for j=1:length(loc)
            
            out = [out matpacks.iofun.levelrecur(in, in.SeriesID(loc(j)))];
            
%             out
        end   
        
    else 
        
%         disp(ID)
        out = ID;
    
    end
    
end