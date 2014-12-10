function  out = plus(obj1, obj2)

%PLUS  Class operation plus (+)
%
%   out = PLUS(obj1, obj2) is the same as out = obj1 + obj2

out = operate(obj1, obj2, str2func(mfilename));