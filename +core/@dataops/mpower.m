function  out = mpower(obj1, obj2)

%MPOWER  Class operation matrix power (^)
%
%   out = MPOWER(obj1, obj2) is the same as out = obj1^obj2

out = operate(obj1, obj2, @power);