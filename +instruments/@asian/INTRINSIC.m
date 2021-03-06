function out = INTRINSIC(obj, Type, S, X, T, V, R, Q)
% intrinsic - intrinsic value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 7
        error('instruments.option.Intrinsic: %s','Not enough parameters to calculate Intrinsic Value');
    end;
    if iscell(Type) || ischar(Type)
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.blacksholes: %s','Option type error');
    end
    
    out = max(exp( -Q .* T) .* type .* S - type .* exp(-R  .* T) .* X, 0 );
    
end

