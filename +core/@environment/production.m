function production

%PRODUCTION Sets the environment variables to production

ValidNames  = gist.environment.validnames;

for i = 1:numel(ValidNames);
    gist.environment.set(ValidNames{i}, mfilename);
end


