function out = blackscholes(obj, param)
% Black - Black Futures Option Price formula
%  Compute the black futures option based on the parameters specified 
%  using the inputs from obj
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
%   a = a.optioncalc(a,'all')


if nargin == 1; param = [];         end;
if isempty(param); param = 'All';   end;

% size out
%out = cell(length(obj), 1);
out = obj.initializeoutput();

for i = 1 : 1 : length(obj)
    
    %scalar expand if needed
%     if ~isequal(size(Type),size(S),size(X),size(T),size(Exdef),size(R),size(Q),size(V));
%         [Type, S, V, Exdef, T, X, R, Q] = ...
%             gist.gist.scalarexpand(Type, S, V, Exdef, T, X, R, Q);
%     end

    out(i) = valueSingleObj(obj(i), param);
    
end

    if length(out) == 1
        %repackage single obj
        out = out(1);
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = valueSingleObj( obj, param)
% valueSingleObj will set the call to the valuation function

    type    = obj.Type;
    S       = obj.S;
    X       = obj.X;
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
    
    temp = fh(obj, type, S, X, T, V, R, Q);
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
        out.Delta       = temp.Delta; %option delta
        out.Gamma       = temp.Gamma; %option gamma
        out.Rho         = temp.Rho; %option rho
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
        out.Vega        = temp.Vega; %option vega
        out.Theta       = temp.Theta; %option theta
%        out.Eta         = temp.Eta;
        out.Intrinsic   = INTRINSIC(obj, type, S, X, T, V, R, Q); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, type, S, X, T, V, R, Q);
    else
        error('Invalid Option Parameter');
    end
    
    
    out = out;
end

function out = NPV(obj, Type, S, X, T, V, R, Q)
% npv is the core pricer calculation function

    type = obj.setType(Type);
%     if iscell(Type) || ischar(Type)
%         %type = ones(size(Type,1),1);
%         type = ones(size(Type));
%         type(strcmpi(Type,'p'))  = -1;
%     elseif strcmpi(class(Type),'double')
%         type = Type;
%     else
%         error('gist:instruments:option:%s: %s', mfilename, 'Option type error');
%     end
    
    out = NaN(size(S));
    indx = (T>=0);
    if ~isempty(indx)
        d1 = (log(S(indx) ./ X(indx)) + (R(indx) - Q(indx) + ...
            (V(indx) .^ 2) ./ 2) .* T(indx) ) ./ (V(indx) .* sqrt(T(indx)));
        d2 = d1 - V(indx) .* sqrt(T(indx));

        out(indx) = exp( -Q(indx) .* T(indx)) .* type(indx) .* S(indx) .* normcdf(type(indx) .* d1) - ...
            type(indx) .* exp(-R(indx)  .* T(indx)) .*X(indx) .* normcdf(type(indx) .* d2);
    end
    % if negative T call intrinsic
    indx = logical(abs(indx - 1)); %change the index for T<0
    if any(indx);
        out(indx) = INTRINSIC(obj, type(indx), S(indx), X(indx), ...
            T(indx), V(indx), R(indx), Q(indx));
    end
    out = out;
end


function out = DELTA(obj, call_flag, S, X, T, v, r, q)
%% Greeks
% $Version History:$
%         Rev 1.1  -  30-Mar 2011   added instrument import, moved option 
%               m-files to package,and changed code below to include 
%               instrument.xxx in the calls.
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S + 0.001, X, T, v, r, q) - ...
    NPV(obj, call_flag, S - 0.001, X, T, v, r, q)) ./ (2 * 0.001));
end

function out = VEGA(obj, call_flag, S, X, T, v, r, q)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, T, v + .01, r, q) - ...
    NPV(obj, call_flag, S, X, T, v - .01, r, q)) ./ (2 * 0.01));
end

function out = GAMMA(obj, call_flag, S, X, T, v, r, q)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S + 0.01, X, T, v, r, q) + ...
    NPV(obj, call_flag, S - 0.01, X, T, v, r, q) - 2 * ...
    NPV(obj, call_flag, S, X, T, v, r, q)) ./ ...
    (0.01)); 
end

function out = THETA(obj, call_flag, S, X, T, v, r, q)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S, X, T - (1/365), v, r, q) - ...
    NPV(obj, call_flag, S, X, T, v, r, q);

end

function out = RHO(obj, call_flag, S, X, T, v, r, q)
% Compute Rho using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, T, v, r + .0001, q) - ...
    NPV(obj, call_flag, S, X, T, v, r - .0001, q)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S, X, T, V, R, Q)
    out = obj;
    out.NPV   = NPV(out, type, S, X, T, V, R, Q);
    out.Delta = DELTA(out, type, S, X, T, V, R, Q);
    out.Gamma = GAMMA(out, type, S, X, T, V, R, Q);
    out.Theta = THETA(out, type, S, X, T, V, R, Q);
    out.Vega  = VEGA(out, type, S, X, T, V, R, Q);
    out.Rho   = RHO(out, type, S, X, T, V, R, Q);
%     out.Phi   = phi(out, type, S, X, T, V, R, Q);
%     out.Eta   = eta(out, type, S, X, T, V, R, Q);
end