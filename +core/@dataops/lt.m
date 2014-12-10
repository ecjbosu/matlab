function  out = lt(obj1, obj2)

%LT  Class operation less than (<)
%
%   out = LT(obj1, obj2) is the same as out = obj1 < obj2

out = operate(obj1, obj2, str2func(mfilename));