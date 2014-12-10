function out = get(varargin)

%GET Gets the environment variables

%   Parse Inputs

if isscalar(varargin) && iscell(varargin{1});
    varargin = varargin{1};
end

%   Extract PathFlag

if islogical(varargin{end})
    PathFlag      = varargin{end};
    varargin(end) = [];
else
    PathFlag = true;
end

%   Error Checking

ValidNames = gist.environment.validnames;

if ~all(ismember(varargin, ValidNames));
    disp('Valid names are:')
    disp(sprintf('%s, ', ValidNames{:}))
    error('Invalid Input: Valid environment name required.  See gist.environment.validnames')
end

%   Initialize Output

out = cell(size(varargin));

%   Get Global env 

for i = 1:numel(varargin)
    out{i} = getpref('Gist', varargin{i});
end

%   Process PathFlag

if ~PathFlag
    
    ValidSettings = gist.environment.validsettings;
   
    for i = 1:numel(varargin)
        indx   = ~cellfun(@isempty, regexpi(out{i}, ValidSettings, 'once'));
        
        if ~any(indx)
            out{i} = 'local';
        else
            out{i} = ValidSettings{indx};
        end
    end
    
end    

%   Scalar Cell Expansion

if isscalar(out);   out = out{1};   end

