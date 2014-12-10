function out = matlabDefaultUserpath

%matlabDefaultUserpath	Returns the default user path name
%unless the user executes and addpath for this directory


%get system variable to create the path string
% homepath    = getenv('HOMEPATH');
% homedrv     = getenv('HOMEDRIVE');
userprofile = getenv('USERPROFILE');
docpath     = 'Documents';
matlb       = 'MATLAB';

%generate the path
out = fullfile(userprofile, docpath, matlb);
