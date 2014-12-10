%  Custon Environment Startup

if ~isdeployed

    disp('*************** Startup ************')

    pathNm = strrep(userpath, 'startup;', 'matlab');
    cd(pathNm)
    
    
    % set the rootSharePath. This is needed for fail safe and BCP since
    % hard codeing the URL in the *path.m files in problematic
    setpref('core','rootPath', '\\share\to\geoLoc\dataLoc');
    
    if ~isempty(which('matlabpool'))
        geoLoc   = 'Houston';
        dataLoc = 'local';
    else
        geoLoc   = 'Houston';
        dataLoc = 'Production';
    end
    
    core.environment.startup(dataLoc, geoLoc);

    %   Import Packages
    core.environment.import();

    clear


end