function  out = rdivide(obj1, obj2)

%RDIVIDE  Class operation componentwise division (./)
%
%   out = RDIVIDE(obj1, obj2) is the same as out = obj1 ./ obj2

out = operate(obj1, obj2, @rdivide);