function  out = all(obj, AxisIndx)

%ALL  Class logical operation all
%
%   out = ALL(obj)
if nargin<1
    error('gist:dataops:all:Invalid inputs %s ', 'Not enough inputs');
end
if nargin<2;     AxisIndx = 1;                                       end

out = loperate(obj, str2func(mfilename), AxisIndx);