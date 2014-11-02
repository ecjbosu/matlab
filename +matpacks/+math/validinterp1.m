function out = validinterp1( in )
%VALIDINTERP1 Check if the specified curve model is valid.
%
%   in = input data
%   

    if nargin < 1 || isempty(in) 
        error('A curve model name is required');
    end
    validnames = {  'nearest' 'linear' 'spline' 'pchip' 'cubic' 'pchip' ...
      'v5cubic'};
    out = ismember( in , validnames) ;

end

