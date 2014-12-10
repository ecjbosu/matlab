function  out = uminus(obj)

%UMINUS  Class operation unary minus (-)
%
%   out = UMINUS(obj) is the same as out = -obj

out = operate(obj, -1, @times);