function development

%DEVELOPMENT Sets the environment variables to development

ValidNames  = gist.environment.validnames;

for i = 1:numel(ValidNames);
    gist.environment.set(ValidNames{i}, mfilename);
end


