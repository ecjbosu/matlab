function out = pricer(obj, param)
% Geske Option on Option - Option Price formula
%    Geske (1977), Geske (1979b), Hodges and Selby (1987),
%    Rubinstein (1991a) et al.
%    Haug, Chpater 2.6

%  Paramters:
%       All
%       Price/Premium
%       Delta, Gamma, Vega, Theta, RHO, Psi, Eta
%  Example:
%   import instruments.*
%   a=option(option,repmat('American',5,1),repmat('p',5,1),repmat(10,5,1), ...
%    repmat(10,5,1),repmat(.5,5,1),repmat(.2,5,1),repmat(.03,5,1),repmat(0,5,1))
%   a = a.optioncalc(a,'NPV')
%   a = a.optioncalc(a,'delta') 
%   a = a.optioncalc(a,'vega')
%   a = a.optioncalc(a,'Gamma')
%   a = a.optioncalc(a,'theta')
%   a = a.optioncalc(a,'RHO')
%   a = a.optioncalc(a,'all')

%TODO : Psi and Eta   

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
    S1      = obj.S;
    S2      = obj.S2;
    X       = obj.X;
    V1      = obj.V;
    V2      = obj.V2;
    T       = obj.T;
    RHO     = obj.RHO;
    R       = obj.R;
    Q1      = obj.Q1;
    Q2      = obj.Q2;  
    exer    = obj.Exdef;
    
    if strcmpi(exer, 'american')
        warning('An AMERICAN option is using the BLACKSHOLES formula');
    end
    
    %fh = str2func(strcat('@', lower(param)));
    fh = str2func(upper(param));
    
     temp = fh(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
     out = obj;
    
    % populate results
    if strcmpi(param, 'npv')
        out.NPV = temp;
    elseif strcmpi(param, 'delta')
        out.Delta = temp;
    elseif strcmpi(param, 'gamma')
        out.Gamma = temp;
    elseif strcmpi(param, 'RHO')
        out.RHO = temp;
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
        out.Delta       = temp.Delta; %option delta
        out.Gamma       = temp.Gamma; %option gamma
        out.RHO         = temp.RHO; %option RHO
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
        out.Vega        = temp.Vega; %option vega
        out.Theta       = temp.Theta; %option theta
%        out.Eta         = temp.Eta;
        out.Intrinsic   = INTRINSIC(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    else
        error('Invalid Option Parameter');
    end
    
%    out.Intrinsic   = intrinsicvalue(type, S, X, X1, T, V, R, Q); %option instrinsic value
%    out.PayoutTerm  = termPayout(type, S, X, X1, T, V, R, Q);
    
    out = out;
end

function out = NPV(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
% npv is the core option calculation function
    %function(TypeFlag = c('cc', 'cp', 'pc', 'pp'), S, X1, X2, T1, Time2, r, b, sigma)
        
    if iscell(type) || ischar(type)
        %type = ones(size(Type,1),1);
        type = ones(size(type,1),size(type,2));
        type(strcmpi(type,'p'))  = -1;
    elseif strcmpi(class(type),'double')
        type = type;
    else
        error('instruments.quotientsOption: %s','Option type error');
    end
    indx = (T>=0);
    if ~isempty(indx)
        
        % get the blended volatility for the quotient option
        sigma_adj = sqrt(V1(indx).^2 - 2 .* RHO(indx) .* V1(indx) .* V2(indx) + V2(indx)^2);
        g1 = R(indx) - Q1(indx);
        g2 = R(indx) - Q2(indx);
        d1 = (1 ./ (sigma_adj .* sqrt(T(indx)))) .* (log(S1(indx) ./ ...
            (X(indx) .* S2(indx))) + (g2 - g1 - 0.5 .* V1(indx) .^ 2 + ...
            0.5 .* V2(indx) .^ 2) .* T(indx)); 
        d2 = d1 + sigma_adj .* sqrt(T(indx));
        F = 0;
    out(indx) = type(indx) .* exp(R(indx)-T(indx)) .* ((S1(indx) ./ S2(indx)) .* ...
        exp(g2 - g1 - R(indx) .* T(indx) + V2(indx) .* (V2(indx) - RHO(indx) ...
        .* V1(indx)) .* T(indx)) .*  normcdf(type(indx) .* d1) - ...
        X(indx) .* normcdf (type(indx) .* d2));
    end
    indx = logical(abs(indx - 1)); %change the index for T<0
    if any(indx);
       out(indx) = 0;
    end
    
    
end


function out = DELTAS1(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
%% Greeks
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S1 + 0.005, S2, X, T, V1, V2, RHO, R, Q1, Q2) - ...
    NPV(obj, call_flag, S1 - 0.005, S2, X, T, V1, V2, RHO, R, Q1, Q2)) ./ (2 * 0.005));
end

function out = DELTAS2(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
%% Greeks
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S1 + 0.005, S2, X, T, V1, V2, RHO, R, Q1, Q2) - ...
    NPV(obj, call_flag, S1 - 0.005, S2, X, T, V1, V2, RHO, R, Q1, Q2)) ./ (2 * 0.005));
end



function out = VEGAV1(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S1, S2, X, T, V1 + 0.005, V2, RHO, R, Q1, Q2) - ...
    NPV(obj, call_flag, S1, S2, X, T, V1 - 0.005, V2, RHO, R, Q1, Q2)) ./ (2 * 0.005));
end


function out = VEGAV2(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S1, S2, X, T, V1, V2 + 0.005, RHO, R, Q1, Q2) - ...
    NPV(obj, call_flag, S1, S2, X, T, V1, V2 - 0.005, RHO, R, Q1, Q2)) ./ (2 * 0.005));
end



function out = GAMMAS1(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S1 + 0.01, S2, X, T, V1, V2, RHO, R, Q1, Q2) + ...
    NPV(obj, call_flag, S1 - 0.01, S2, X, T, V1, V2, RHO, R, Q1, Q2) - 2 * ...
    NPV(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)) ./ ...
    (0.01)); 
end


function out = GAMMAS2(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S1, S2 + 0.01, X, T, V1, V2, RHO, R, Q1, Q2) + ...
    NPV(obj, call_flag, S1, S2 - 0.01, X, T, V1, V2, RHO, R, Q1, Q2) - 2 * ...
    NPV(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)) ./ ...
    (0.01)); 
end


function out = THETA(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S1, S2, X, T - (1/365), V1, V2, RHO, R, Q1, Q2) - ...
    NPV(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);

end

function out = RHO(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
% Compute RHO using two-sided finite difference method
out = ((NPV(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R + 0.0001, Q1, Q2) - ...
    NPV(obj, call_flag, S1, S2, X, T, V1, V2, RHO, R - 0.0001, Q1, Q2)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2)
    out = obj;
    out.NPV   = NPV(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.DeltaS1 = DELTAS1(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.DeltaS1 = DELTAS2(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.Gamma = GAMMAS1(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.Gamma = GAMMAS2(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.Theta = THETA(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.VegaS1  = VEGAV1(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.VegaS2 = VEGAV2(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
    out.RHO   = RHO(obj, type, S1, S2, X, T, V1, V2, RHO, R, Q1, Q2);
%     out.Phi   = PHI(out, type, S, X, X1, T, V, R, Q);
%     out.Eta   = ETA(out, type, S, X, X1, T, V, R, Q);
end
