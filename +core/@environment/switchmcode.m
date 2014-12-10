function switchmcode(PathName)


%SWICTHMCODE	Switches the mcode environment
%
%   environment.switchmcode(PathName)
%
%       Sets the mcode environment to the given PathName

%   Error Checking

if nargin < 1 || isempty(PathName); error('Missing required input: PathName');  end

%   Set rootpath

gist.environment.rootpath(PathName)

%   Get dbMartName Setting

dbMartName = regexpi(gist.environment.get('DatabaseRead'),[gist.environment.validsettings], 'match');
dbMartName = [dbMartName{:}];

%   Startup

gist.environment.startup(dbMartName{1}, gist.environment.globallocation);

%   Clear Classes

clear classes

%   Change Directory

cd(gist.environment.mfilespath)