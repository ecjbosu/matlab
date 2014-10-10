function out = PAYOUT(obj, Type, S, X, T, V, R, Q, G)
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
    
    % set default to 1 dollar for dcon
    out = zeros(size(obj.S, 1), size(obj.S, 2));
    indx = type .* S > type .* X;
    if strcmpi(obj.Typedef, 'con')
        % set to zero if out ouf the money
        out(indx) = 1;
    elseif strcmpi(obj.Typedef, 'gap')
        out(indx) = type(indx) .* (S(indx) - G(indx));
    elseif strcmpi(obj.Typedef, 'aon')
        out(indx) = S(indx);
    else
        error('Invalid option Typedef');
    end
        % Zhang uses wS > wK
    
end

