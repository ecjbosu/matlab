function  out = any(obj, AxisIndx)

%ANY  Class logical operation any
%
%   out = ANY(obj)
if nargin<1
    error('gist:dataops:any:Invalid inputs', 'Not enough inputs');
end
if nargin<2;     AxisIndx = 1;                                       end

out = loperate(obj, str2func(mfilename), AxisIndx);