function out = mfilespath

%MCODEPATH	Returns the mcode path name

out = fullfile(gist.environment.rootpath, 'mfiles');
