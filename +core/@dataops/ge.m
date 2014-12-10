function  out = ge(obj1, obj2)

%GE  Class operation greater than or equal to (>=)
%
%   out = GE(obj1, obj2) is the same as out = obj1 >= obj2

out = operate(obj1, obj2, str2func(mfilename));