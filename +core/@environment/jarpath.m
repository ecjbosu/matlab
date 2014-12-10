function out = jarpath

%DLLPATH	Returns the dll path name

out = fullfile(gist.environment.externalpath, 'jar');
