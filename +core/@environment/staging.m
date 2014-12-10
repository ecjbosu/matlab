function staging

%STAGING Sets the environment variables to staging

ValidNames  = gist.environment.validnames;

for i = 1:numel(ValidNames);
    gist.environment.set(ValidNames{i}, mfilename);
end


