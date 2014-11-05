function out = validdatabaseSource( in )
%validdatabaseSource return true or false for valid datasource

    try
        
        %load default from default preferences
        link = core.environment.nargsin('Programs', mfilename, 1);
        
    catch EX
        
        % use default if core not loaded
        link = {'MySQL', 'Oracle','MSSQL'};
        
    end
    
    out = ismember(in, link);
    
end

