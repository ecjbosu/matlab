function local(PathName)

%LOCAL Sets the environment variables to local

%   Parse Inputs

if nargin == 1; gist.environment.localpath(PathName); end

%   ValidNames Loop

ValidNames  = gist.environment.validnames;

for i = 1:numel(ValidNames);
    gist.environment.set(ValidNames{i}, mfilename);
end


