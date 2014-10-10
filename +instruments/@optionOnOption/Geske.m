function out = Geske(obj, param)
% Geske Option on Option - Option Price formula
%    Geske (1977), Geske (1979b), Hodges and Selby (1987),
%    Rubinstein (1991a) et al.
%    Haug, Chpater 2.6

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

    type    = obj.Type;
    S       = obj.S;
    X       = obj.X;
    X1      = obj.X1;
    V       = obj.V;
    T       = obj.T;
    T1      = obj.T1;
    R       = obj.R;
    Q       = obj.Q;
    exer    = obj.Exdef;
    
    if strcmpi(exer, 'american')
        warning('An AMERICAN option is using the BLACKSHOLES formula');
    end
    
    %fh = str2func(strcat('@', lower(param)));
    fh = str2func(upper(param));
    
    temp = fh(obj, type, S, X, X1, T, T1, V, R, Q);
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
        out.Intrinsic   = INTRINSIC(obj, type, S, X, X1, T, T1, V, R, Q); %option instrinsic value
        out.PayoutTerm  = PAYOUT(obj, type, S, X, X1, T, T1, V, R, Q);
    else
        error('Invalid Option Parameter');
    end
    
%    out.Intrinsic   = intrinsicvalue(type, S, X, X1, T, V, R, Q); %option instrinsic value
%    out.PayoutTerm  = termPayout(type, S, X, X1, T, V, R, Q);
    
    out = out;
end

function out = NPV(obj, Type, S, X, X1, T1, T2, V, R, Q)
% npv is the core option calculation function
    %function(TypeFlag = c('cc', 'cp', 'pc', 'pp'), S, X1, X2, T1, Time2, r, b, sigma)
        
    indx = (T1>=0);
    if ~isempty(indx)
        rho = sqrt (T1(indx) ./ T2(indx));
        
        %Compound Option type
        type2 = ones(size(Type(indx),1), 1);
        type2(strcmpi(Type(indx), 'pp') | strcmpi(Type(indx), 'cp')) = -1;
        %Underlying Option type
        type = ones(size(Type(indx),1), 1);
        type(strncmpi(Type(indx), 'p', 1)) = -1;

        I = CriticalValueOptionOnOption(type2(indx), X(indx), X1(indx), ...
            T2(indx)-T1(indx), V(indx), R(indx), Q(indx));

        y1 = (log(S(indx) ./ I(indx)) + (R(indx) - Q(indx) + ...
            V(indx) .^ 2 ./ 2) .* T1(indx)) ./ (V .* sqrt(T1(indx)));
        y2 = y1 - V(indx) .* sqrt (T1(indx));
        z1 = (log(S(indx) ./ X(indx)) + (R(indx) - Q(indx) + ...
            V(indx) .^ 2 ./ 2) .* T2(indx)) ./ (V .* sqrt(T2(indx)));
        z2 = z1 - V(indx) .* sqrt (T2(indx));

        n = size(rho, 1);
        z = [rho zeros(n, 1)];
        z = reshape(z' ,n * 2 , 1);
        z = z(1:end);
        zo = [ones(n, 1) zeros(n, 1)];
        zo = reshape(zo' ,n * 2 , 1);
        zo = zo(1:end);

       % z1 = eye(n*2) + diag(z, 1) + diag(z, -1); %create a standard normal bivariate covariance matrix.
        z = [circshift(z, 1) + zo z + circshift(zo, 1)];
        z = reshape(z.',[4 n])'; % get a vectorize z for arrayfunc
        z = reshape(z',[2 ,2, n]);

        %Type for use in the vectorized payout formula
        type1 = repmat(fliplr(eye(2)) , [1 1 n]) .* ...
            reshape([type type type type]', [2 2 n]) + repmat(eye(2), [1 1 n]);

        if any(~ismember(Type,{'cc' 'cp' 'pc' 'pp'}'))
            error('Invalid type flag');
        else
              out = ( type2 .* type .* S(indx) .* exp (-Q(indx) .* T2(indx)) .* ...
                    my_mvncdf(type2 .* z1, type2 .* type .* y1, type1 .* z) - ...
                   type2 .* type .* X(indx) .* exp(-R(indx) .* T2(indx)) .* ...
                    my_mvncdf(type2 .* z2, type2 .* type .* y2, type1 .* z) - ...
                   type .* X1(indx) .* exp(-R(indx) .* T1(indx)) .* normcdf(type2 .* type .* y2));
        end
    % if negative T set to zero and move UND here
    indx = abs(indx - 1); %change the index for T<0
    if any(indx);
       out(indx) = 0;
    end
    end
    
end

function out = my_mvncdf(a, b, z)
%my_mvncdf is a wrapper function to facilitate the call to mvncdf.
%   arrayfun requires all dimensions to be the same for input parameters 
    %convert z to Nx1 cell array of standard normal covariance matrices
    z = squeeze(num2cell(z,[1 2]));
    %arrayfun requires all dimensions to be the same for input parameters,
    %so build the zero means vector
    z0=zeros(size(a,1),1);
 
    %execute the arrayfun, this is cool
    out = arrayfun(@(a, b, z0, z)mvncdf([a b]', z0, cell2mat(z)), ...
        a ,b ,z0 ,z, 'UniformOutput',false);
    out = cell2mat(out); %convert cell back to matrix, easier here than in 
                         % the option value function above

end

function out = DELTA(obj, call_flag, S, X, X1, T, T2, v, r, q)
%% Greeks
% $Version History:$
%         Rev 1.1  -  30-Mar 2011   added instrument import, moved option 
%               m-files to package,and changed code below to include 
%               instrument.xxx in the calls.
% Compute Delta using two-sided finite difference method
out = ((NPV(obj, call_flag, S + 0.005, X, X1, T, T2, v, r, q) - ...
    NPV(obj, call_flag, S - 0.005, X, X1, T, T2, v, r, q)) ./ (2 * 0.005));
end

function out = VEGA(obj, call_flag, S, X, X1, T, T2, v, r, q)
% Compute Vega using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, X1, T, T2, v + .005, r, q) - ...
    NPV(obj, call_flag, S, X, X1, T, T2, v - .005, r, q)) ./ (2 * 0.005));
end

function out = GAMMA(obj, call_flag, S, X, X1, T, T2, v, r, q)
% Compute Gamma using central difference since it is the second derivative
out = ((NPV(obj, call_flag, S + 0.01, X, X1, T, T2, v, r, q) + ...
    NPV(obj, call_flag, S - 0.01, X, X1, T, T2, v, r, q) - 2 * ...
    NPV(obj, call_flag, S, X, X1, T, T2, v, r, q)) ./ ...
    (0.01)); 
end

function out = THETA(obj, call_flag, S, X, X1, T, T2, v, r, q)
% Compute Theta
% backward finite difference
out = NPV(obj, call_flag, S, X, X1, T - (1/365), T2, v, r, q) - ...
    NPV(obj, call_flag, S, X, X1, T, T2, v, r, q);

end

function out = RHO(obj, call_flag, S, X, X1, T, T2, v, r, q)
% Compute Rho using two-sided finite difference method
out = ((NPV(obj, call_flag, S, X, X1, T, T2, v, r + .0001, q) - ...
    NPV(obj, call_flag, S, X, X1, T, T2, v, r - .0001, q)) ./ (2 * 0.0001));
end

function out = ALL(obj, type, S, X, X1, T, T2, V, R, Q)
    out = obj;
    out.NPV   = NPV(out, type, S, X, X1, T, T2, V, R, Q);
    out.Delta = DELTA(out, type, S, X, X1, T, T2, V, R, Q);
    out.Gamma = GAMMA(out, type, S, X, X1, T, T2, V, R, Q);
    out.Theta = THETA(out, type, S, X, X1, T, T2, V, R, Q);
    out.Vega  = VEGA(out, type, S, X, X1, T, T2, V, R, Q);
    out.Rho   = RHO(out, type, S, X, X1, T, T2, V, R, Q);
%     out.Phi   = PHI(out, type, S, X, X1, T, V, R, Q);
%     out.Eta   = ETA(out, type, S, X, X1, T, V, R, Q);
end

function out = CriticalValueOptionOnOption (TypeFlag, X1, X2, T, V, R, Q)
% Calculation of critical price options on options
    o = instruments.option;
    o.Type = TypeFlag;
    o.S    = X1;
    o.X    = X1;
    o.T    = T;
    o.V    = V;
    o.R    = R;
    o.Q    = Q;
    
    o = o.blackscholes('NPV');
    ci = o.NPV;
    o = o.blackscholes('Delta');
    di = o.Delta;
    epsilon = 0.000001;
    o.X = X2; % reset X to X2 for NR algorithm
    % Newton-Raphson algorithm:
%     while (abs(ci - X2) > epsilon) 
%         o.S = o.S - (ci - X2) ./ di;
%         ci = instrument.blackscholes(o, 'NPV');
%         di = instrument.blackscholes(o, 'Delta');
%     end
    
    out = arrayfun(@optionNR_algorithm, ...
        o, 'UniformOutput',false);
    out = out{:}; % make sure not cell
    
end

function out = optionNR_algorithm(obj, ci, di, epsilon)
    % Newton-Raphson algorithm:
    epsilon = 0.000001;
    X2    = obj.X; %bait and switch to work with the object.
    obj.X = obj.S;
    
    while (abs(obj.NPV - X2) > epsilon) 
        obj.S = obj.S - (obj.NPV - X2) ./ obj.Delta;
        obj = obj.blackscholes('NPV');
        ci = obj.NPV;
        obj = obj.blackscholes('Delta');
        di = obj.Delta;
    end
    out = obj.S;

end
