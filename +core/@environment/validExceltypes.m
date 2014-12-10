function out = validExceltypes( )

%validExceltypes	Returns the valid FILE types for the pcWIN excel
%
%   The valid environment names refer to the properties of the global env 
%   variable that may be set:
% 
%   xls 2003
%   xlsm 2010

out = 'xls';
if strcmpi(computer, 'PCWIN64')
    out = 'xlsm';
end

