function  out = times(obj1, obj2)

%TIMES  Class operation componentwise multiplication (.*)
%
%   out = TIMES(obj1, obj2) is the same as out = obj1 .* obj2

out = operate(obj1, obj2, str2func(mfilename));