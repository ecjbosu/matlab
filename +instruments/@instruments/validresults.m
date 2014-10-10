function out = validfiletypes( in )

%VALIDFILETYPES	Returns the valid FILE types that dataset can read/write
%
%   The valid environment names refer to the properties of the global env 
%   variable that may be set:
% 


if nargin < 1 || isempty(in)
    
    error('environment:validfiletypes: %s', 'A valid string is required');
    
end

%ensure cell string

in = cellstr(in);

%create container map

out = containers.Map({'csv'     'xls'   'xpt' 'xlsx' 'xlsm' }, ...
       {'File'    'XLSFile'     'XPTFile'  'XLSFile'   'XLSFile' });
   
idx = ismember(in, keys(out));   

% return original input if not found.  This allows the program to continue
% with a known file type descriptor

if ~all(idx)
    
    out = [];
    
else
    
    out = values(out, in);
    
end
