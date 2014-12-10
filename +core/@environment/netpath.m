function out = netpath

%NETPATH	Returns the net path name

out = fullfile(gist.environment.externalpath, 'net');
