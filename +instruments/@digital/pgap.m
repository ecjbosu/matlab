function out = pgap(obj, param)
% pgap - Gap Digital gap Option Price formula
% based on Zhang 2nd Ed.  Pager 402 - 404


if nargin == 1; param = [];         end;

if isempty(param); param = 'All';   end;

% size out
out = cell(length(obj), 1);

for i = 1 : 1 : length(obj)
    out{i} = valueSingleObj(obj(i), param);
end

    if length(out) == 1
        %repackage single obj
        out = out{1};
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = valueSingleObj( obj, param)
% valueSingleObj will set the call to the valuation function

    type    = obj.Type;
    S       = obj.S;
    X       = obj.X;
    G       = obj.G;
    V       = obj.V;
    T       = obj.T;
    R       = obj.R;
    Q       = obj.Q;
    exer    = obj.Exdef;
    
    if strcmpi(exer, 'american')
        warning('An AMERICAN option is using the BLACKSHOLES formula');
    end
    
   %fh = str2func(strcat('@', lower(param)));
    fh = str2func(upper(param));
    
    temp = fh(obj, type, S, X, T, V, R, Q, G);
    out = obj;
    
    % populate results
    if strcmpi(param, 'npv')
        out.NPV = temp;
    elseif strcmpi(param, 'delta')
        out.Delta = temp;
    elseif strcmpi(param, 'gamma')
        out.Gamma = temp;
    elseif strcmpi(param, 'rho')
        out.Rho = temp;
    elseif strcmpi(param, 'phi')
        out.Phi = temp;
    elseif strcmpi(param, 'vega')
        out.Vega = temp;
    elseif strcmpi(param, 'theta')
        out.Theta = temp;
    elseif strcmpi(param, 'eta')
        out.Eta = temp;
    elseif strcmpi(param, 'intrinsic')
        out.Intrinsic   = temp; %intrinsic(obj, type, S, X, T, V, R, Q, G); %option instrinsic value
    elseif strcmpi(param, 'payout')
        out.PayoutTerm  = temp; %Payout(obj, type, S, X, T, V, R, Q, G);
    elseif strcmpi(param, 'all')
        out.NPV         = temp.NPV; %option premium/value
        out.Delta       = temp.Delta; %option delta
        out.Gamma       = temp.Gamma; %option gamma
        out.Rho         = temp.Rho; %option rho
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
        out.Vega        = temp.Vega; %option vega
        out.Theta       = temp.Theta; %option theta
%        out.Eta         = temp.Eta;
        out.Intrinsic   = INTRINSIC(obj, type, S, X, T, V, R, Q, G); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, type, S, X, T, V, R, Q, G);
    else
        error('Invalid Option Parameter');
    end
    
    
    out = out;
end

function out = NPV(obj, Type, S, X, T, V, R, Q, G)
% npv is the core pricer calculation function
    if iscell(Type) || ischar(Type)
        %type = ones(size(Type,1),1);
        type = ones(size(Type,1),size(Type,2));
        type(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        type = Type;
    else
        error('instruments.option.digital: %s','Option type error');
    end
    
    out = NaN(size(S));
    indx = (T>=0);
    if ~isempty(indx)
        d1 = (log(S(indx) ./ X(indx)) + ((R(indx) - Q(indx) + ...
            (V(indx) .^ 2) ./ 2) .* T(indx)) ) ./ (V(indx) .* sqrt(T(indx)));
        d2 = d1(indx) - V(indx) .* sqrt(T(indx));

        out(indx) = type(indx) .* S(indx) .* exp(-Q(indx) .* T(indx)) .* ...
            normcdf(type .* d1(indx) ) - type(indx) .* G .* ...
            exp(-R(indx)  .* T(indx)) .* normcdf(type(indx) .* d2(indx)); 
    end
    % if negative T call intrinsic
    indx = abs(indx - 1); %change the index for T<0
    if any(indx);
        out(indx) = intrinsic(obj, type(indx), S(indx), X(indx), ...
            T(indx), V(indx), R(indx), Q(indx));
    end
    out = out;
end

function out = DELTA(obj, call_flag, S, X, T, v, r, q, g)
%% Greeks
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S + 0.005, X, T, v, r, q, g) - ...
    NPV(obj, call_flag, S - 0.005, X, T, v, r, q, g)) ./ (2 * 0.005));
end

function out = VEGA(obj, call_flag, S, X, T, v, r, q, g)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, T, v + .005, r, q, g) - ...
    NPV(obj, call_flag, S, X, T, v - .005, r, q, g)) ./ (2 * 0.005));
end

function out = GAMMA(obj, call_flag, S, X, T, v, r, q, g)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S + 0.01, X, T, v, r, q, g) + ...
    NPV(obj, call_flag, S - 0.01, X, T, v, r, q, g) - 2 * ...
    NPV(obj, call_flag, S, X, T, v, r, q, g)) ./ ...
    (0.01)); 
end

function out = THETA(obj, call_flag, S, X, T, v, r, q, g)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S, X, T - (1/365), v, r, q, g) - ...
    NPV(obj, call_flag, S, X, T, v, r, q, g);

end

function out = RHO(obj, call_flag, S, X, T, v, r, q, g)
% Compute Rho using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, T, v, r + .0001, q, g) - ...
    NPV(obj, call_flag, S, X, T, v, r - .0001, q, g)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S, X, T, V, R, Q, G)
    out = obj;
    out.NPV   = NPV(out, type, S, X, T, V, R, Q, G);
    out.Delta = DELTA(out, type, S, X, T, V, R, Q, G);
    out.Gamma = GAMMA(out, type, S, X, T, V, R, Q, G);
    out.Theta = THETA(out, type, S, X, T, V, R, Q, G);
    out.Vega  = VEGA(out, type, S, X, T, V, R, Q, G);
    out.Rho   = RHO(out, type, S, X, T, V, R, Q, G);
%     out.Phi   = phi(out, type, S, X, T, V, R, Q, G);
%     out.Eta   = eta(out, type, S, X, T, V, R, Q, G);
end