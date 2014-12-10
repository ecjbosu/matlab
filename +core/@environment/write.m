function out = write(InputString)

%WRITE Sets and gets the write environment settings
%
%   out = gist.environment.write(InputName) 
%
%       Returns the write environment settings for the given InputName
%       Default = All valid read environment names
%
%   gist.environment.write(InputSetting)
%
%       Sets the write environment settings to InputSetting

%   Import Environment

import gist.environment.*

%   Extract InputNames

InputNames = gist.environment.validnames;
InputNames = InputNames(~cellfun(@isempty,regexp(InputNames, 'Write')));

%   Get or Set

if nargin == 0
    
    %   Get InputNames
    
    out = gist.environment.get(InputNames{:});
    
elseif any(ismember(strrep(InputNames, 'Write', ''), InputString))

    %   Get InputString
    
    out = gist.environment.get([InputString 'Write']);
    
else
        
    %   Set InputNames to InputString

    Inputs          = cell(2*numel(InputNames), 1);
    Inputs(1:2:end) = InputNames;
    Inputs(2:2:end) = {lower(InputString)};

    gist.environment.set(Inputs{:});

end