function set(varargin)

%SET Sets environment variables

%   Parse Inputs

if isscalar(varargin) && iscell(varargin{1});
    varargin = varargin{1};
end

%   Check HostID for Production Set Rights

%hack for production until we get it deployed
ProductionWriteAccess = true; %isdeployed || strcmp(hostid, '100000') || strcmp(hostid, '100001');

%   Extract PathNames

PathNames = gist.environment.pathname(varargin{:});

%   Extract Inputs

InputNames    = varargin(1:2:end);
InputSettings = lower(varargin(2:2:end));

%   Set Global env 

for i = 1:numel(PathNames)

     if ~ProductionWriteAccess && ~isempty(regexpi(InputNames{i}, 'write')) && strcmp(InputSettings{i}, 'production')
        error('Production write access denied')
     elseif ~exist(PathNames{i}, 'dir')
         mkdir(PathNames{i})
     elseif ~exist(PathNames{i}, 'dir')
         error(['Unable to locate path: ' PathNames{i}])
     else
        
        if str2double(getenv('DisplayFlag'))
            disp(['Setting ' InputNames{i} ': ' InputSettings{i}])
        end
        
        setpref('Gist', InputNames{i} , PathNames{i})
     
     end
     
end


