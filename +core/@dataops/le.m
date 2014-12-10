function  out = le(obj1, obj2)

%LE  Class operation less than or equal to (<=)
%
%   out = LE(obj1, obj2) is the same as out = obj1 <= obj2

out = operate(obj1, obj2, str2func(mfilename));