function  out = mldivide(obj1, obj2)

%MLDIVIDE  Class operation matrix left division (\)
%
%   out = MLDIVIDE(obj1, obj2) is the same as out = obj1 \ obj2

out = operate(obj1, obj2, @ldivide);