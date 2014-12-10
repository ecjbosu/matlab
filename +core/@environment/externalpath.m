function out = externalpath

%EXTERNALPATH	Returns the external path name

out = fullfile(gist.environment.rootpath, 'external');
