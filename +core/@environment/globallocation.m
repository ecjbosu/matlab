function out = globallocation(InputName)

%GLOBALLOCATION     Returns and sets the global location

%   Parse Inputs

if nargin < 1
    out = getpref('Gist', 'GlobalLocation');
    return
end

%   Error Checking

if ~ischar(InputName)
    error('Invalid Input:   InputName must be a char')
end

if ~ismember(InputName, gist.environment.validgloballocations)
    error(['Invalid Input: ' InputName ' is not recognized'])
end
    
%   Set Global Location

if str2double(getenv('DisplayFlag'))
    disp(['Setting Global Location: ' InputName])
end

setpref('Gist','GlobalLocation', InputName)
