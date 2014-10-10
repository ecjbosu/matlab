function out = PAYOUT(obj, Type, S, S2, V, V2, Rho, T, X, R, Q, Q2, B, B2)
% termPayout - termPayout value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 14
        error('instruments.optionOnOption.PAYOUT: %s','Not enough parameters to calculate Payout Value');
    end;
    if iscell(Type) || ischar(Type)
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.blacksholes: %s','Option type error');
    end
    
    out = max(type .* B .* S - type .* X - type .* B2 .* S2, 0 );

end

