function startup(InputSetting, GlobalLocation, AddAssembliesFlag)

%STARTUP    Initializes the gist platform

%   Parse Inputs

if nargin < 1 || isempty(InputSetting);       InputSetting      = '';    end
if nargin < 2 || isempty(GlobalLocation);     GlobalLocation    = '';    end
if nargin < 3 || isempty(AddAssembliesFlag);  AddAssembliesFlag = true;  end

%   Question Dialog

if isempty(GlobalLocation)

    ValidLocations = gist.environment.validgloballocations;
    GlobalLocation = questdlg('Which Regional Location?', 'Set Regional Location' ,ValidLocations{1:end}, ValidLocations{1});

end
    
if isempty(InputSetting)

    
    ValidSettings = gist.environment.validsettings;
    ReadEnv       = questdlg('Which dbMart Environment?', 'Set dbMart Environment' ,ValidSettings{[1 3 5]}, ValidSettings{1});

    if strcmp(ReadEnv, 'production');   WriteEnv = 'development';
    else                                WriteEnv = ReadEnv;
    end
    
else
    ReadEnv  = InputSetting;
    WriteEnv = InputSetting;
end
   
  %Display Flag

setenv('DisplayFlag', '1')

%   Waitbar Flag

setenv('WaitbarFlag', '1')

%set the environment preference
setpref('Gist','Environment', ReadEnv)

%   Set DBMart Environment

gist.environment.localpath(gist.environment.rootpath);
gist.environment.globallocation(GlobalLocation);
gist.environment.read(ReadEnv);
gist.environment.write(WriteEnv);
gist.environment.set('Applications', ReadEnv);

%   Add Environment Paths

if ~isdeployed

    %   Add Paths
    
    addpath(userpath)
    addpath(gist.environment.scriptspath)
    addpath(gist.environment.rootpath);
    addpath(gist.environment.pfilespath);
    addpath(gist.environment.mfilespath);
    
    %   Deep Add Paths
    
    gist.environment.deepaddpath(gist.environment.binpath)
    gist.environment.deepaddpath(gist.environment.externalpath)
    gist.environment.deepaddpath(gist.environment.jarpath, true)
    
end

%   Add .NET Assemblies

if AddAssembliesFlag
    gist.environment.addassemblies
end


