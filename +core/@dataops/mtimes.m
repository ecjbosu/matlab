function  out = mtimes(obj1, obj2)

%MTIMES  Class operation matrix multiplication (*)
%
%   out = MTIMES(obj1, obj2) is the same as out = obj1 * obj2

out = operate(obj1, obj2, @times);