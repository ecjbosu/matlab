function out = binpath

%BINPATH	Returns the compiled path name

out = fullfile(gist.environment.rootpath, 'bin');
