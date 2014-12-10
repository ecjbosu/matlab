function out = scriptspath

%SCRIPTSPATH	Returns the scripts path name

out = fullfile(gist.environment.rootpath, 'Scripts');
