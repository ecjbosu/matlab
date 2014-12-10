function out = validnames

%VALIDNAMES	Returns the valid environment names
%
%   The valid environment names refer to the properties of the global env 
%   variable that may be set:
% 
%   DatabaseRead 
%   DatabaseWrite
%   CacheRead
%   CacheWrite
%   XmlRead
%   XmlWrite
%   Applications

out = {'RootRead'     'RootWrite'       ...
       'DatabaseRead' 'DatabaseWrite'   ...
       'CacheRead'    'CacheWrite'      ...
       'XmlRead'      'XmlWrite'        ...
       'Applications' 'Logpath'};
