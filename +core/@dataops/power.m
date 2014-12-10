function  out = power(obj1, obj2)

%POWER  Class operation componentwise power (^)
%
%   out = POWER(obj1, obj2) is the same as out = obj1.^obj2

out = operate(obj1, obj2, str2func(mfilename));