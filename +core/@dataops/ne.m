function  out = ne(obj1, obj2)

%NE  Class operation not equal to (~=)
%
%   out = NE(obj1, obj2) is the same as out = obj1 ~= obj2

out = operate(obj1, obj2, str2func(mfilename));