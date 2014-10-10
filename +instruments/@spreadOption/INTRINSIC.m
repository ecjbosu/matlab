function out = INTRINSIC(obj, Type, S, S2, V, V2, Rho, T, X, R, Q, Q2, B, B2)
% intrinsic - intrinsic value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 14
        error('instruments.option.Intrinsic: %s','Not enough parameters to calculate Intrinsic Value');
    end;
    if iscell(Type) || ischar(Type)
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.spreadOption: %s','Option type error');
    end
    
    out = max(exp( -Q .* T) .* type .* B .* S - type .* exp(-R  .* T) .* X ...
        - exp( -Q2 .* T) .* type .* B2 .* S2, 0 );
    
    
end

