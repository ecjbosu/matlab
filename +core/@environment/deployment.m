function    deployment(LocalPathName, WaitBar, GlobalLocation)

%DEPLOYMENT   Sets the environment for deployed applications

%   Parse Inputs

if nargin < 1 || isempty(LocalPathName)
    LocalPathName = gist.environment.localpath;   
end

if nargin < 2 || isempty(WaitBar)
    WaitBar = [];
end

if nargin < 3 || isempty(GlobalLocation)
        GlobalLocation = 'Houston';
end

%   Ensure No fbMart in LocalPathName

LocalPathName = strrep(LocalPathName, '\fbMart', '');

%   Set DisplayFlag

setenv('DisplayFlag', '0')

%   Set ShowHiddenHandles

set(0,'ShowHiddenHandles','on')

if ~isempty(WaitBar)
    waitbar(1/2, WaitBar, ['Setting Global Location to ' GlobalLocation ' ...'])
end

gist.environment.globallocation(GlobalLocation);

%   Determine dbmart Environment Setting

if ismember(lower(LocalPathName), gist.environment.validsettings)

    gist.environment.(lower(LocalPathName)); %#ok
    EnvironmentSetting = LocalPathName;

elseif exist(fullfile(LocalPathName, 'dbmart'), 'dir')

    gist.environment.localpath(LocalPathName);
    gist.environment.local;
    
    ValidSettings = gist.environment.validsettings;
    SettingIndx   = find(~cellfun(@isempty, regexpi(LocalPathName, ValidSettings)));
    
    if      numel(SettingIndx) == 0; EnvironmentSetting = 'Local Relative';
    elseif  numel(SettingIndx) == 1; EnvironmentSetting = ValidSettings{SettingIndx};
    else    
        error(['Invalid LocalPathName: ' LocalPathName])
    end
    
elseif exist(fullfile(gist.environment.localpath, 'dbmart'), 'dir')
    gist.environment.local;
    EnvironmentSetting = 'Local C:\gist';
elseif exist(gist.environment.scenariopath, 'dir')
    EnvironmentSetting = 'Beta';
    gist.environment.beta;
else
    error('Unable to locate dbmart')
end

%   Set dbmart Environment Setting

EnvironmentSetting(1) = upper(EnvironmentSetting(1));

if ~isempty(WaitBar)
    waitbar(5/8, WaitBar, ['Setting Environment to ' EnvironmentSetting ' ...'])
end

%   Ensure MipDirectFlag

if isempty(gist.environment.mipdirectflag)
    gist.environment.mipdirectflag(true)
end
    
