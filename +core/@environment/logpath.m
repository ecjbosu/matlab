function out = logpath

%LOGPATH	Returns the log path name

out = fullfile(gist.environment.rootpath, 'Logs');
%out = '\\AD-HOUSTON01\Share\NG Trading\Risk\logs';

out = fullfile(getpref('Gist','rootSharePath'), 'dbMarts', getpref('Gist', 'Environment'), 'logs');
%out = fullfile('c:\temp', getpref('Gist', 'Environment'), 'logs');