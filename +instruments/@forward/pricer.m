function out = pricer(obj, param)
% forward - forward/Futures Price formula
%  Compute the futures based on the parameters specified 
%  using the inputs from obj
%  Paramters:
%       All
%       Price/Premium
%       Delta, Gamma, Vega, Theta, Rho, Psi, Eta
%  Example:
%   import instruments.*
%   a=option(option,repmat('American',5,1),repmat('p',5,1),repmat(10,5,1), ...
%    repmat(10,5,1),repmat(.5,5,1),repmat(.03,5,1),repmat(0,5,1))
%   a = a.optioncalc(a,'NPV')
%   a = a.optioncalc(a,'delta') 
%   a = a.optioncalc(a,'theta')
%   a = a.optioncalc(a,'rho')
%   a = a.optioncalc(a,'all')

%TODO : 1 Psi and Eta   
%       2 Delta
%       3 Rho
%       4 Theta

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
    T       = obj.T;
    R       = obj.R;
    Q       = obj.Q;

    
    fh = str2func(upper(param));
    
    temp = fh(obj, type, S, X, T, R, Q);
    out = obj;
    
    % populate results
    if strcmpi(param, 'npv')
        out.NPV = temp;
    elseif strcmpi(param, 'delta')
        out.Delta = temp;
    elseif strcmpi(param, 'rho')
        out.Rho = temp;
    elseif strcmpi(param, 'phi')
        out.Phi = temp;
    elseif strcmpi(param, 'theta')
        out.Theta = temp;
    elseif strcmpi(param, 'eta')
        out.Eta = temp;
    elseif strcmpi(param, 'intrinsic')
        out.Intrinsic   = temp; %intrinsic(obj, type, S, X, T, R, Q); %option instrinsic value
    elseif strcmpi(param, 'payout')
        out.PayoutTerm  = temp; %Payout(obj, type, S, X, T, R, Q);
    elseif strcmpi(param, 'all')
        out.NPV         = temp.NPV; %option premium/value
%        out.Delta       = temp.Delta; %option delta
%        out.Rho         = temp.Rho; %option rho
%        out.Phi         = temp.Phi; %option Phi (dividend yield)
%        out.Theta       = temp.Theta; %option theta
%        out.Eta         = temp.Eta;
        out.Intrinsic   = INTRINSIC(obj, S, X, T, R, Q); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, S, X, T, R, Q);
    else
        error('Invalid Option Parameter');
    end
   
    out = out;
end

function out = NPV(obj, Type, S, X, T, R, Q)
% npv is the core blackscholes calculation function
    
    out = NaN(size(S));
    indx = (T>=0);
    if ~isempty(indx)
        indx1 = strcmpi(Type, 'swap');
        if any(indx1)
            out(indx) = S(indx) - X(indx);
        end
        indx1 = strcmpi(Type, 'forward');
        if any(indx1)
              out(indx) = (S(indx) - X(indx)) .* exp(-R(indx) .* T(indx));
        end
        indx1 = strcmpi(Type, 'fwd');
        if any(indx1)
              out(indx) = (S(indx) - X(indx));
        end
          
    end
    % if negative T call intrinsic
    indx = logical(abs(indx - 1)); %change the index for T<0
    if any(indx);
        out(indx) = INTRINSIC(obj, S(indx), X(indx), T(indx), R(indx), Q(indx));
    end
    out = out;
end


function out = DELTA(obj, call_flag, S, X, T, r, q)
%% Greeks
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S + 0.005, X, T, r, q) - ...
    NPV(obj, call_flag, S - 0.005, X, T,r, q)) ./ (2 * 0.005));
end

function out = THETA(obj, call_flag, S, X, T,  r, q)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S, X, T - (1/365), r, q) - ...
    NPV(obj, call_flag, S, X, T,r, q);

end

function out = RHO(obj, call_flag, S, X, T, r, q)
% Compute Rho using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, T, r + .0001, q) - ...
    NPV(obj, call_flag, S, X, T, r - .0001, q)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S, X, T, R, Q)
    out = obj;
    out.NPV   = NPV(out, type, S, X, T, R, Q);
%    out.Delta = DELTA(out, type, S, X, T, R, Q);
%    out.Theta = THETA(out, type, S, X, T, R, Q);
%    out.Rho   = RHO(out, type, S, X, T, R, Q);
%     out.Phi   = phi(out, type, S, X, T, R, Q);
%     out.Eta   = eta(out, type, S, X, T, R, Q);
end