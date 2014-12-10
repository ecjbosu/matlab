function  out = and(obj1, obj2)

%AND  Class logical operation and (&)
%
%   out = AND(obj1, obj2) is the same as out = obj1 & obj2

out = operate(obj1, obj2, str2func(mfilename));