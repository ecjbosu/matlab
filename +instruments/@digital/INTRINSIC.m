function out = INTRINSIC(obj, Type, S, X, T, V, R, Q, G)
% intrinsic - intrinsic value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : can I handle the intrinsic for each digital?

    if nargin < 7
        error('instruments.option.Intrinsic: %s','Not enough parameters to calculate Intrinsic Value');
    end;
    if iscell(Type) || ischar(Type)
        %type = ones(size(Type,1),1);
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.digital: %s','Option type error');
    end
    
    % set default to 1 dollar for dcon
    out = zeros(size(obj.S, 1), size(obj.S, 2));
    indx = type .* S > type .* X;
    if strcmpi(obj.Typedef, 'con')
        % set to zero if out ouf the money
        out(indx) = 1;
    elseif strcmpi(obj.Typedef, 'gap')
        out(indx) = type(indx) .* (exp( -Q(indx) .* T(indx)) .* S(indx) - exp(-R(indx)  .* T(indx)) .* G(indx));
    elseif strcmpi(obj.Typedef, 'aon')
        out(indx) = exp( -Q(indx) .* T(indx)) .* S(indx);
    else
        error('Invalid option Typedef');
    end
    shift = ones(size(obj.S, 1), size(obj.S, 2)); % to change the sign since
        % Zhang uses wS > wK
    out(exp( -Q .* T) .* shift .* type .* S <= shift .* type .* exp(-R  .* T) .* X) = 0;
        
end

