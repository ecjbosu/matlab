function out = localpath(PathName)

%LOCALPATH	Returns or Sets the local path name
%
%   out = environment.localpath
%
%       Returns the local path name (Default = fileparts(userpath) which
%       defaults to 'C:\METMAT')
%
%   environment.localpath(PathName)
%
%       Sets the local path to the given PathName

if nargin < 1 || isempty(PathName)

    out = getenv('LocalPath');

    if isempty(out)
        out = fileparts(userpath);
        
        if ~exist(out, 'dir')
            out = tempdir;
        end
        
        setenv('LocalPath', out);
    end
    
elseif nargin == 1 && ischar(PathName) && exist(PathName, 'dir')

    if str2double(getenv('DisplayFlag'))
        disp(['Setting LocalPath: ' PathName])
    end
    
    setenv('LocalPath', PathName);

else
    
    error('Invalid Input:  PathName must be a recognized folder')
    
end
