function  out = mrdivide(obj1, obj2)

%MRDIVIDE  Class operation matrix right division (/)
%
%   out = MRDIVIDE(obj1, obj2) is the same as out = obj1 / obj2

out = operate(obj1, obj2, @rdivide);