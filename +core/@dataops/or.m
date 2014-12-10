function  out = or(obj1, obj2)

%OR  Class logical operation or (|)
%
%   out = OR(obj1, obj2) is the same as out = obj1 | obj2

out = operate(obj1, obj2, str2func(mfilename));