function out = waitbarflag(InputValue)

%WaitbarFlag    Returns and sets the global waitbar flag

%   Parse Inputs

if nargin < 1
    out = logical(str2double(getenv('WaitbarFlag')));
    return
end

%   Error Checking

if ~islogical(InputValue) && ~isscalar(InputValue)
    error('Invalid Input:   InputValue must be a scalar logical')
end

%   Convert InputValue to Char

if InputValue;  InputValue = '1';
else            InputValue = '0';
end

%   Set WaitbarFlag

if str2double(getenv('DisplayFlag'))
    disp(['Setting WaitbarFlag: ' InputValue])
end

setenv('WaitbarFlag', InputValue)
