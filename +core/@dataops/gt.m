function  out = gt(obj1, obj2)

%GT  Class operation greater than (>)
%
%   out = GT(obj1, obj2) is the same as out = obj1 > obj2

out = operate(obj1, obj2, str2func(mfilename));