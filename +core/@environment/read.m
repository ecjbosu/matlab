function out = read(InputString)

%READ Sets the read environment variables

%   out = gist.environment.read(InputName) 
%
%       Returns the write environment settings for the given InputName
%       Default = All valid read environment names
%
%   gist.environment.read(InputSetting)
%
%       Sets the read environment settings to InputSetting

%   Import gist Environment

import gist.environment

%   Extract InputNames

InputNames = gist.environment.validnames;
InputNames = InputNames(~cellfun(@isempty,regexp(InputNames, 'Read')));

%   Get or Set

if nargin == 0
    
    %   Get InputNames
    
    out = gist.environment.get(InputNames{:});
    
elseif any(ismember(strrep(InputNames, 'Read', ''), InputString))

    %   Get InputString
    
    out = gist.environment.get([InputString 'Read']);
    
else
        
    %   Set InputNames to InputString

    Inputs          = cell(2*numel(InputNames), 1);
    Inputs(1:2:end) = InputNames;
    Inputs(2:2:end) = {lower(InputString)};

    gist.environment.set(Inputs{:});

end