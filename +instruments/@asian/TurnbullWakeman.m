function out = TurnbullWakeman(obj, param)
% TurnbullWakeman - Asian Option Price formula
% Turnbull-Wakeman Approximation 
% Based on Huag 2007 2nd ed Turnbull-Wakeman pp 186-189.
% And Haug 2nd Edition
%
% ONLY for Average Price Options
%  Paramters:
%       All
%       Price/Premium
%       Delta, Gamma, Vega, Theta, Rho, Psi, Eta
%  Example:
%   import instruments.*
%   a=option(option,repmat('American',5,1),repmat('p',5,1),repmat(10,5,1), ...
%    repmat(10,5,1),repmat(.5,5,1),repmat(.2,5,1),repmat(.03,5,1),repmat(0,5,1))
%   a = a.optioncalc(a,'NPV')
%   a = a.optioncalc(a,'DELTA') 
%   a = a.optioncalc(a,'VEGA')
%   a = a.optioncalc(a,'Gamma')
%   a = a.optioncalc(a,'THETA')
%   a = a.optioncalc(a,'RHO')
%   a = a.optioncalc(a,'all')

%TODO : 1 Psi and Eta   
%       2 Intrinsic calculation and 
%       3 Vol time adjustment for Vol see Hull and Haug
%       4 Add functionality to accept a dataset or struct with the
%       appropriate field/VarNames. Modify the constuctor to get this feature.
%       

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
    SA      = obj.SA;
    X       = obj.X;
    V       = obj.V;
    T       = obj.T;
    T2      = obj.T2;
    R       = obj.R;
    Q       = obj.Q;
    exer    = obj.Exdef;
    
    if strcmpi(exer, 'american')
        warning('An AMERICAN option is using the BLACKSHOLES formula');
    end
    
    fh = str2func(upper(param));
    
    temp = fh(obj, type, S, SA, X, T, T2, V, R, Q);
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
        out.Intrinsic   = temp; %intrinsic(obj, type, S, X, T, V, R, Q); %option instrinsic value
    elseif strcmpi(param, 'payout')
        out.PayoutTerm  = temp; %Payout(obj, type, S, X, T, V, R, Q);
    elseif strcmpi(param, 'all')
        out.NPV         = temp.NPV; %option premium/value
        out.Delta       = temp.Delta; %option DELTA
        out.Gamma       = temp.Gamma; %option GAMMA
        out.Rho         = temp.Rho; %option RHO
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
        out.Vega        = temp.Vega; %option VEGA
        out.Theta       = temp.Theta; %option THETA
%        out.Eta         = temp.Eta;
        out.Intrinsic   = INTRINSIC(obj, type, S, X, T, V, R, Q); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, type, S, X, T, V, R, Q);
    else
        error('Invalid Option Parameter');
    end
    
%    out.Intrinsic   = intrinsicvalue(type, S, X, T, V, R, Q); %option instrinsic value
%    out.PayoutTerm  = termPayout(type, S, X, T, V, R, Q);
    out = out;
end

function out = NPV(obj, Type, S, SA, X, T, T2, V, R, Q)
% NPV is the core asian option calculation function
% Based on Huag 2007 2nd ed Turnbull-Wakeman pp 186-189.
    
    if strcmpi(obj.Typedef ,'asian')
        import instruments.option.*;
        ih = str2func('instruments.option');
        fh = str2func('option.blackschles');
    elseif strcmpi(obj.Typedef, 'aon')
        import instruments.digital.*;
        ih = str2func('instruments.digital');
        %ih.Typedef = obj.Typedef;
        fh = str2func('digital.aon');
        G = zeros(size(S, 1), size(S, 2));
    elseif strcmpi(obj.Typedef, 'con')
        import instruments.digital.*;
        ih = str2func('instruments.digital');
        %ih.Typedef = obj.Typedef;
        fh = str2func('digital.con');
        G = zeros(size(S, 1), size(S, 2));
    else
        error('Invalid Asian typedef');
    end
    
    out = nan(size(S,1), size(S,2));
    %boundary conditions and time to first fixing set
      % set call/put flag
    Type = Type;
    S = max(S, 1e-6);
    V = max(V, 1e-6);
    X = X;
    R = R;
    Q = Q;
    T = T;
    SA = max(SA, 1e-6);
    % set cost of carry as in Haug
    
    b = R - Q;
    
    tindx = find(T==0);
    if ~isempty(tindx)
        T2(tindx) = 2*(1e-6);
        T(tindx) = T(tindx) + T2(tindx);
    end
    % define time to averaging period
    % note tau is negative when in averaging period
    t1 = max(0, T - T2);
    tau = T2 - T; 
    
    % Haug extension for asian option on futures 1999
    if b == 0
        m1 = 1;
        m2 = (2 * exp( V.^ 2 .* T) - 2 * exp(V.^ 2 .* t1) .* ...
            (1 + V.^2 .* (T - t1))) ./ (V.^4 .* (T - t1) .^ 2);
    else
        m1 = (exp( b .* T) - exp( b .* t1)) ./ (b .* (T - t1));
        m2 = 2 * exp((2 * b + V.^ 2) .* T) ./ ...
            ((b + V .^ 2) .* ( 2 * b + V.^2) .* (T -t1).^2) ...
            + 2 * exp(( 2 * b + V.^2) .* t1) ./ ...
            (b .* (T - t1).^2) .* ((( 2 * b + V.^2) .^ -1) - ...
            exp(b .* (T - t1)) ./ ( b + V.^2));
    end
    
    % Adjust cost of carry and volatility of the average on the futures
    bA = log(m1) ./ T;
    % adjust for R and Q on option formula instead of cost of carry.
    Q = R - bA;
    V = sqrt(log(m2) ./ T - 2 * bA);
    
    % outside averaging period, do the standard option calc
    tindx = tau < 0;
    if any(tindx)
        %out(tindx) = fh.optioncalc(tobj(tindx), 'NPV')';
        tobj = ih(ih(), obj.Exdef(tindx), Type(tindx), S(tindx), X(tindx), ...
            T(tindx), V(tindx), R(tindx), Q(tindx));
        tobj.Typedef = obj.Typedef;
        out(tindx) = tobj.optioncalc(tobj, 'NPV').('NPV');
    end
    
    tindx = logical(abs(tindx - 1));
    
    % inside averaging periods handle 2 special cases
    % case 1 call option exercised with 100% probability and put = 0
    %   call method option.instrinsic
    cpindx = strcmpi(Type, 'c') & (T2 ./ T .* X - tau ./ T .* SA < 0);
    if any(cpindx & tindx)
        tobj = ih(ih(), obj.Exdef(cpindx & tindx), Type(cpindx & tindx), ...
            S(cpindx & tindx), X(cpindx & tindx), T(cpindx & tindx), ...
            V(cpindx & tindx), R(cpindx & tindx), Q(cpindx & tindx));
        tobj.Typedef = obj.Typedef;
        tobj.S = SA(cpindx & tindx) .* ...
            (-tau(cpindx & tindx))./ T2(cpindx & tindx) + ...
            tobj.S(cpindx & tindx) .* tobj.T(cpindx & tindx) ...
            ./ T2(cpindx & tindx) - tobj.X(cpindx & tindx);
        out(cpindx & tindx) = tobj.optioncalc(tobj,'INTRINSIC').('INTRINSIC');
    end
    % handle puts
    cpindx = strcmpi(Type, 'p') & (T2 ./ T .* X - tau ./ T .* SA < 0);
    if any(cpindx & tindx)
        out(cpindx & tindx) = 0;
    end
    
    % case 2 inside averaging period replace strike
    % adjust the strike price to be used in the black model 
    cpindx = (T2 ./ T .* X - tau ./ T .* SA >= 0);
    if any(cpindx & tindx)
        tobj = ih(ih(), obj.Exdef(cpindx & tindx), Type(cpindx & tindx), ...
            S(cpindx & tindx), X(cpindx & tindx), T(cpindx & tindx), ...
            V(cpindx & tindx), R(cpindx & tindx), Q(cpindx & tindx));
        tobj.Typedef = obj.Typedef;
        tobj.X(cpindx & tindx) = (X(cpindx & tindx) .* ...
            T2(cpindx & tindx) ./ T(cpindx & tindx) + ...
            SA(cpindx & tindx) .* tau(cpindx & tindx) ./ ...
            T(cpindx & tindx));
        out(cpindx & tindx) = tobj.optioncalc(tobj, 'NPV').('NPV');
        out(cpindx & tindx) = out(cpindx & tindx) .* tobj.T ./ T2(cpindx & tindx);
    end
  
end


function out = DELTA(obj, call_flag, S, SA, X, T, T2, v, r, q)
%% Greeks
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S + 0.005, SA, X, T, T2, v, r, q) - ...
    NPV(obj, call_flag, S - 0.005, SA, X, T, T2, v, r, q)) ./ (2 * 0.005));
end

function out = VEGA(obj, call_flag, S, SA, X, T, T2, v, r, q)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S, SA, X, T, T2, v + .005, r, q) - ...
    NPV(obj, call_flag, S, SA, X, T, T2, v - .005, r, q)) ./ (2 * 0.005));
end

function out = GAMMA(obj, call_flag, S, SA, X, T, T2, v, r, q)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S + 0.01, SA, X, T, T2, v, r, q) + ...
    NPV(obj, call_flag, S - 0.01, SA, X, T, T2, v, r, q) - 2 * ...
    NPV(obj, call_flag, S, SA, X, T, T2, v, r, q)) ./ ...
    (0.01)); 
end

function out = THETA(obj, call_flag, S, SA, X, T, T2, v, r, q)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S, SA, X, T - (1/365), T2, v, r, q) - ...
    NPV(obj, call_flag, S, SA, X, T, T2, v, r, q);

end

function out = RHO(obj, call_flag, S, SA, X, T, T2, v, r, q)
% Compute Rho using two-sided finite difference method
out = ((NPV(obj, call_flag, S, SA, X, T, T2, v, r + .0001, q) - ...
    NPV(obj, call_flag, S, SA, X, T, T2, v, r - .0001, q)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S, SA, X, T, T2, V, R, Q)
    out = obj;
    out.NPV   = NPV(out, type, S, SA, X, T, T2, V, R, Q);
    out.Delta = DELTA(out, type, S, SA, X, T, T2, V, R, Q);
    out.Gamma = GAMMA(out, type, S, SA, X, T, T2, V, R, Q);
    out.Theta = THETA(out, type, S, SA, X, T, T2, V, R, Q);
    out.Vega  = VEGA(out, type, S, SA, X, T, T2, V, R, Q);
    out.Rho   = RHO(out, type, S, SA, X, T, T2, V, R, Q);
%     out.Phi   = phi(out, type, S, SA, X, T, T2, V, R, Q);
%     out.Eta   = eta(out, type, S, SA, X, T, T2, V, R, Q);
end