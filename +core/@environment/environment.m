classdef environment

    %ENVIRONMENT    environment Abstract package
    
    methods (Static)

        %   Setting & Getting
        
        set(varargin)

        out = get(varargin)
        out = read(InputSetting)
        out = write(InputSetting)
        out = globallocation(InputName)
        out = waitbarflag(InputValue)
        out = mipdirectflag(InputFlag)
        
        production
        staging
        beta
        development
        local
        deployment(LocalPathName, WaitBar, GlobalLocation)
        switchmcode(PathName)
        out = currentEnvironmentPath
        
        
        %   Valid Names & Settings
        
        out = validnames
        out = validsettings
        out = validgloballocations
        out = validfiletypes( in )
        out = validExceltypes( )
        
        %   PathNames
        
        out = pathname(varargin)        
        
        out = rootpath(PathName)
        out = localpath(PathName)
        out = scriptspath
        out = mfilespath
        out = pfilespath
        out = binpath
        out = externalpath
        out = logpath
        
        out = netpath
        out = jarpath
        
        out = developmentpath(GlobalLocation)
        out = betapath(GlobalLocation)
        out = stagingpath(GlobalLocation)
        out = productionpath(GlobalLocation)
        
        out = matlabDefaultUserpath
        out = tnsnamespath
                
        %   Other
        
        startup(InputSetting, GlobalLocation, AddAssembliesFlag)
        updatefromproduction(EnvironmentSettings, KeyMasters, FileTypes)
        deepaddpath(PathName, JavaFlag)
        addassemblies(PathName)
        import(full)
        
        %Defaults
        out = nargsin( KeyMaster, mfile, narg, varargin )
    end
    
end

