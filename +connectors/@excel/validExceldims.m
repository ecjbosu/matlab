function out = validExceldims( )

%validExceltypes	Returns the valid FILE types for the pcWIN excel
%
%   The valid environment names refer to the properties of the global env 
%   variable that may be set:
% 
%   xls 2003
%   xlsm 2010

out = [65536 256];
if strcmpi(computer, 'PCWIN64')
    out = [1048576 16384];
end

