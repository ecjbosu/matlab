function  out = eq(obj1, obj2)

%EQ  Class operation equal to (==)
%
%   out = EQ(obj1, obj2) is the same as out = obj1 == obj2

out = operate(obj1, obj2, str2func(mfilename));