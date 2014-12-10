function  out = isempty(obj)

%ISEMPTY Class logical operation isempty
%
%   out = NOT(obj)

out = loperate(obj, str2func(mfilename));