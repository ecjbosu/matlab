function out = currentEnvironmentPath()

%CURRENTENVIRONMENTPATH	Returns the current environment path name

out = getpref('Gist', 'RootRead');
out = strrep(out, '\dbMarts\', '');
