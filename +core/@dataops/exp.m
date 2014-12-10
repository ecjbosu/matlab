function  out = exp(obj)

%EXP  Class operation exp

% %   obj.exp
% %
% %   OR
% %
% %   out = obj.exp;
% 
% %   Initialize Output
% 
% out = initializeoutput(obj, nargout);

%   Operate

out = uoperate(obj, str2func(mfilename));