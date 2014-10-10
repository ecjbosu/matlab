function out = PAYOUT(obj, Type, S, X, T, V, R, Q)
% termPayout - termPayout value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 7
        error('instruments.option.Payout: %s','Not enough parameters to calculate Payout Value');
    end;
    if iscell(Type) || ischar(Type)
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.blacksholes: %s','Option type error');
    end
    
    out = max(type .* S - type .* X, 0 );
    
end

