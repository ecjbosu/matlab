function out = rootpath(PathName)

%ROOTPATH	Returns or Sets the root path name to the gist installation
%
%   out = gist.environment.rootpath
%
%       Returns the root path name (Default = fileparts(userpath) which
%
%
%   gist.environment.rootpath(PathName)
%
%       Sets the root path to the given PathName

if nargin < 1 || isempty(PathName)

    out = getenv('RootPath');

    if isempty(out)
        out = fileparts(userpath);
        
        if ~exist(out, 'dir')
            error(['Missing Root Folder: ' out])
        end
        
        setenv('RootPath', out);

    end
    
elseif nargin == 1 && ischar(PathName)

    %   Ensure Full PathName
    
    if isempty(fileparts(PathName))
        PathName = fullfile(fileparts(getenv('RootPath')), PathName);
    end
        
    %   Error Checking
    
    if ~exist(PathName, 'dir')
        error(['Unable to locate Path: ' PathName])
    end
    
    %   Set Rootpath
    
    disp(['Setting RootPath: ' PathName])
    setenv('RootPath', PathName);
    
    %   Set Userpath
    
    if ~isdeployed
        
        UserPath = fullfile(PathName, 'startup');

        if exist(UserPath, 'dir')
            disp(['Setting Userpath: ' UserPath])
            userpath(UserPath)
        else
            warning(['Unable to locate Path: ' UserPath])
        end
    end
    
else
    
    error('Invalid Input:  PathName must be a recognized folder')
    
end
