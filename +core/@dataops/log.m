function  out = log(obj)

%LOG  Class operation log

% %   obj.log
% %
% %   OR
% %
% %   out = obj.log;
% 
% %   Initialize Output
% 
% out = initializeoutput(obj, nargout);

%   Operate

out = uoperate(obj, str2func(mfilename));