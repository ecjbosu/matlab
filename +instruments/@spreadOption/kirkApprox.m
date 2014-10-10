function out = kirkApprox(obj, param)
% Geske Option on Option - Option Price formula
%    Kirk Approxijation,
%    Exotic Options Chapter 2
%    Haug, pp 213-214

%  Paramters:
%       All
%       Price/Premium
%       Delta, Gamma, Vega, Theta, Rho, Psi, Eta
%  Example:
%   import instruments.*
%   a=option(option,repmat('American',5,1),repmat('p',5,1),repmat(10,5,1), ...
%    repmat(10,5,1),repmat(.5,5,1),repmat(.2,5,1),repmat(.03,5,1),repmat(0,5,1))
%   a = a.optioncalc(a,'NPV')
%   a = a.optioncalc(a,'delta') 
%   a = a.optioncalc(a,'vega')
%   a = a.optioncalc(a,'Gamma')
%   a = a.optioncalc(a,'theta')
%   a = a.optioncalc(a,'rho')
%   a = a.optioncalc(a,'ALL')

%TODO : Psi and Eta   

if nargin == 1; param = [];         end;
if isempty(param); param = 'All';   end;

% size out
out = cell(length(obj), 1);

for i = 1 : 1 : length(obj)
    out{i} = valueSingleObj(obj(i), param);
end


    
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = valueSingleObj( obj, param)
% valueSingleObj will set the call to the valuation function

    type     = obj.Type;
    S1       = obj.S;
    S2       = obj.S2;
    V1       = obj.V;
    V2       = obj.V2;
    Corr      = obj.Corr;
    Q1       = obj.Q;
    Q2       = obj. Q2;
    T        = obj.T;
    X        = obj.X;
    R        = obj.R;
    B        = obj.B;
    B2       = obj.B2;
    
    exer     = obj.Exdef;
    
    if strcmpi(exer, 'american')
        warning('An AMERICAN option is using the BLACKSHOLES formula');
    end
    
    fh = str2func(upper(param));
    
    temp = fh(obj, type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2);
    out = obj;
    
    % populate results
    if strcmpi(param, 'NPV')
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
        out.Intrinsic = temp;
    elseif strcmpi(param, 'payoutterm')
        out.PayoutTerm = temp;
    elseif strcmpi(param, 'ALL')
        out.NPV         = temp.NPV; %option premium/value
        out.Delta       = temp.Delta; %option delta
        out.Gamma       = temp.Gamma; %option gamma
        out.Rho         = temp.Rho; %option rho
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
        out.Vega        = temp.Vega; %option vega
        out.Theta       = temp.Theta; %option theta
        out.Intrinsic  = temp.Intrinsic;
%        out.Eta         = temp.Eta;
        out.PayoutTerm  = temp.PayoutTerm;
    else
        error('Invalid Option Parameter');
    end
    
%    out.Intrinsic   = intrinsicvalue(type, S, X, X1, T, V, R, Q); %option instrinsic value
%    out.PayoutTerm  = termPayout(type, S, X, X1, T, V, R, Q);
    
    out = out;
end

function out = NPV(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)
% NPV is the core option calculation function
    %function(TypeFlag = c('cc', 'cp', 'pc', 'pp'), S, X1, X2, T1, Time2, r, b, sigma)
        
     type = ones(size(Type, 1), size(Type, 2));
     type(strcmpi(Type, 'p')) = -1;
     
     
    S = B .* S1 .* exp(-Q1 .* T) ./ ...
        (B2 .* S2 .* exp(-Q2 .* T) + X .* exp(-R .* T));
    F = B2 .* S2 .* exp(-Q2 .* T) ./ ...
        (B2 .* S2 .* exp(-Q2 .* T) + X .* exp(-R .* T));
    
   
    vol = sqrt(V2 .^ 2 +(V1 .* F) .^ 2 - 2 .* Corr .* V2 .* V1 .* F);
    %handle the special case when vol ends up zero like v1 = v1 and corr =
    indx = vol ~= 0; 
    d1 = zeros(size(vol));
    d1(indx) = (log(S(indx)) + (vol(indx) .^ 2 / 2) .* T(indx)) ./ ...
        (vol(indx) .* sqrt(T(indx)));
    d1(~indx) = 0;
    d2 = d1 - vol .* sqrt(T);
    
    out = nan(size(T));
    
    out(indx) = (B2(indx) .* S2(indx) .* exp(- Q2(indx).* T(indx)) + ...
        X(indx) .* exp(-R(indx) .* T(indx))) .* ...
        (type(indx) .* (S(indx) .* normcdf(type(indx) .* d1(indx)) - ...
        normcdf(type(indx) .* d2(indx))));
    % handle the special case that vol ends up zero
    out(~indx) = INTRINSIC(obj, Type(~indx), S1(~indx), S2(~indx), ...
        V1(~indx), V2(~indx), Corr(~indx), T(~indx), X(~indx), ...
        R(~indx), Q1(~indx), Q2(~indx), B(~indx), B2(~indx));
          
end

function out = DELTA(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)
%% Greeks
% Compute Delta using two-sided finite difference method
ds = .001;

out{1} = ((NPV(obj, Type, S1 + ds, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1 - ds, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)) ./ (2 * ds)) ./ B;

out{2} = ((NPV(obj, Type, S1, S2 + ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1, S2 - ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)) ./ (2 * ds)) ./ B2;

end

function out = VEGA(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)
% % Compute Vega using two-sided finite difference method
ds = .0001;
out{1}=((NPV(obj, Type, S1, S2, V1 + ds, V2, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1, S2, V1 - ds, V2, Corr, T, X, R, Q1, Q2, B, B2)) ./ (2 * ds));

out{2}= ((NPV(obj, Type, S1, S2, V1, V2 + ds, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1, S2, V1, V2 - ds, Corr, T, X, R, Q1, Q2, B, B2)) ./ (2 * ds));
%cross vega 
out{3} = ((NPV(obj, Type, S1, S2, V1 + ds, V2 + ds, Corr, T, X, R, Q1, Q2, B, B2) + ...
    NPV(obj, Type, S1, S2, V1 - ds, V2 - ds, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1, S2, V1 - ds, V2 + ds, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1, S2, V1 + ds, V2 - ds, Corr, T, X, R, Q1, Q2, B, B2)) ./ ...
    (4 * ds ^2)) ./ 10000;  % 10000 scale factor from haug 2nd edition.
%

end

function out = GAMMA(obj, Type, S1, S2, V1, V2, Corr, T, X, R,Q1, Q2, B, B2)
% Compute Gamma using central difference since it is the second derivative
% out = ((NPV(obj, call_flag, S + 0.01, X, X1, T, T2, v, r, q) + ...
%     NPV(obj, call_flag, S - 0.01, X, X1, T, T2, v, r, q) - 2 * ...
%     NPV(obj, call_flag, S, X, X1, T, T2, v, r, q)) ./ ...
%     (0.01)); 

ds = 0.01;

out{1} = ((NPV(obj, Type, S1 + ds, S2, V1, V2, Corr, T, X, R,Q1, Q2, B, B2) + ...
    NPV(obj, Type, S1 - ds, S2, V1, V2, Corr, T, X, R,Q1, Q2, B, B2) - 2 * ...
    NPV(obj, Type, S1, S2, V1, V2, Corr, T, X, R,Q1, Q2, B, B2)) ./ ...
    (ds ^2 ));  
%using ds * 100 for gamma as cents/UOM  .01 ^ 2 * 100 = .01
out{1} = out{1} ./ 100;

out{2} = ((NPV(obj, Type, S1, S2 + ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) + ...
    NPV(obj, Type, S1 , S2 - ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) - 2 * ...
    NPV(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)) ./ ...
    (ds ^2)); 
%using ds * 100 for gamma as cents/UOM  .01 ^ 2 * 100 = .01
out{2} = out{2} ./ 100;

out{3} = ((NPV(obj, Type, S1 + ds, S2 + ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) + ...
    NPV(obj, Type, S1 - ds , S2 - ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1 - ds, S2 + ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1 + ds , S2 - ds, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)) ./ ...
    (4 * ds ^2)); 
%using ds * 100 for gamma as cents/UOM  .01 ^ 2 * 100 = .01
out{3} = out{3} ./ 100;

end

function out = THETA(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)
% Compute Theta
% backward finite difference
% out = NPV(obj, call_flag, S, X, X1, T - (1/365), T2, v, r, q) - ...
%     NPV(obj, call_flag, S, X, X1, T, T2, v, r, q);

%determine more than 1 day to expiraty options
indx = T>1/365;
out = nan(size(T));

%need to figure out how to get rid of the reshapes
out(indx) = NPV(obj, reshape(Type(indx), size(T(indx))), reshape(S1(indx), size(T(indx))), ...
    reshape(S2(indx), size(T(indx))), reshape(V1(indx), size(T(indx))), ...
    reshape(V2(indx), size(T(indx))), reshape(Corr(indx), size(T(indx))), ...
    reshape(T(indx), size(T(indx))) - (1/365), ...
    reshape(X(indx), size(T(indx))), reshape(R(indx), size(T(indx))), ...
    reshape(Q1(indx), size(T(indx))), reshape(Q2(indx), size(T(indx))), ...
    reshape(B(indx), size(T(indx))), reshape(B2(indx), size(T(indx)))) - ...
    NPV(obj, reshape(Type(indx), size(T(indx))), reshape(S1(indx), size(T(indx))), ...
    reshape(S2(indx), size(T(indx))), reshape(V1(indx), size(T(indx))), reshape(V2(indx), size(T(indx))), ...
    reshape(Corr(indx), size(T(indx))), reshape(T(indx), size(T(indx))), reshape(X(indx), size(T(indx))), ...
    reshape(R(indx), size(T(indx))), reshape(Q1(indx), size(T(indx))), reshape(Q2(indx), size(T(indx))), ...
    reshape(B(indx), size(T(indx))), reshape(B2(indx), size(T(indx))));
% one day to expiry options is Payout less value today
indx = logical(abs(indx - 1));
if all(all(indx))
    out(indx) =  PAYOUT(obj, reshape(Type(indx), size(T(indx))), reshape(S1(indx), size(T(indx))), ...
        reshape(S2(indx), size(T(indx))), reshape(V1(indx), size(T(indx))), ...
        reshape(V2(indx), size(T(indx))), reshape(Corr(indx), size(T(indx))), ...
        reshape(T(indx), size(T(indx))), reshape(X(indx), size(T(indx))), ...
        reshape(R(indx), size(T(indx))), reshape(Q1(indx), size(T(indx))), ...
        reshape(Q2(indx), size(T(indx))), reshape(B(indx), size(T(indx))), reshape(B2(indx), size(T(indx)))) - ...
        NPV(obj, reshape(Type(indx), size(T(indx))), reshape(S1(indx), size(T(indx))), ...
        reshape(S2(indx), size(T(indx))), reshape(V1(indx), size(T(indx))), reshape(V2(indx), size(T(indx))), ...
        reshape(Corr(indx), size(T(indx))), reshape(T(indx), size(T(indx))), reshape(X(indx), size(T(indx))), ...
        reshape(R(indx), size(T(indx))), reshape(Q1(indx), size(T(indx))), reshape(Q2(indx), size(T(indx))), ...
        reshape(B(indx), size(T(indx))), reshape(B2(indx), size(T(indx))));
end

end

function out = RHO(obj, Type, S1, S2, V1, V2, Corr, T, X, R, Q1, Q2, B, B2)
% Compute Corr using two-sided finite difference method
% out = ((NPV(obj, call_flag, S, X, X1, T, T2, v, r + .0001, q) - ...
%     NPV(obj, call_flag, S, X, X1, T, T2, v, r - .0001, q)) ./ (2 * 0.0001));
ds = .0001;

out = ((NPV(obj, Type, S1 + 0.01, S2, V1, V2, Corr, T, X, R + ds, Q1, Q2, B, B2) - ...
    NPV(obj, Type, S1 + 0.01, S2, V1, V2, Corr, T, X, R - ds, Q1, Q2, B, B2)) ./ (2 * ds));

end

function out = ALL(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2)
    out = obj;
    out.NPV         = NPV(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.Delta       = DELTA(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.Gamma       = GAMMA(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.Theta       = THETA(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.Vega        = VEGA(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.Rho         = RHO(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
%     out.Phi   = PHI(out, type, S, X, X1, T, V, R, Q, B, B2);
%     out.Eta   = ETA(out, type, S, X, X1, T, V, R, Q, B, B2);
    out.Intrinsic  = INTRINSIC(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
    out.PayoutTerm = PAYOUT(obj, Type, S, S2, V, V2, Corr, T, X, R, Q, Q2, B, B2);
end

