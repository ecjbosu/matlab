function out = validsettings

%VALIDSETTINGS	Returns the valid environment settings
%
%   The valid environment settings refer to the values to which the valid 
%   environment names may be set:
% 
%       Production Staging Beta Development Local
 
out = {'production' 'staging' 'development' 'beta' 'local'};

