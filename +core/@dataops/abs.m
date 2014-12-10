function  out = abs(obj)

%ABS  Class operation log

% %   obj.abs
% %
% %   OR
% %
% %   out = obj.abs;
% 
% %   Initialize Output
% 
% out = initializeoutput(obj, nargout);

%   Operate

out = uoperate(obj, str2func(mfilename));