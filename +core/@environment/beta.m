function beta

%BETA   Sets the environment variables to beta

ValidNames  = gist.environment.validnames;

for i = 1:numel(ValidNames);
    gist.environment.set(ValidNames{i}, mfilename);
end


