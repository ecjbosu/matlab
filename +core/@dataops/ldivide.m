function  out = ldivide(obj1, obj2)

%LDIVIDE  Class operation componentwise left division (.\)
%
%   out = LDIVIDE(obj1, obj2) is the same as out = obj1 .\ obj2

out = operate(obj1, obj2, str2func(mfilename));