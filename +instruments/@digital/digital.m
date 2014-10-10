classdef digital < instruments.option
    %digital option class to for properties
    %   Digital class with properties
    %   Default Digital single asset option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.
    %   Key is the function/class handle for that will facilitate
    %   overloading option classes and methods
    %
    %   Digital Options based on Zhang 2nd Ed. Chapter 15 for Europeans
    %   and American.  European option types are Cash or Nothing, Gap, and
    %   Asset or Nothing (dcon, pgap, aon pricing methods).
    
    % TODO: American Digitals, supershares, and correlation spread/switch
    % digital options
%    
%  Result Paramters:
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

%TODO : 1 Psi and Eta   
%       3 Vol time adjustment for Vol see Hull and Haug
%       4 Add functionality to accept a dataset or struct with the
%       appropriate field/VarNames. Modify the constuctor to get this feature.
%       5 If input parameters differ in size add repication along the
%       longest parameter dimesions, ie S = 20X1 adn X = 1X1
%       repmat(X,size(S,1)) for all parameters this way.
%       6 Add if parameter is multi-dimensional, S = 20X20, and others are
%       a singleton, X = 20X1, add functions to replicate the object along
%       the non-singleton dimension.
%       7.  How to value the obj with different TypeDefs
    
   properties
       G = []; %Gap option parameter                    
   end
   properties (SetAccess = protected)
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.
%         NPV         = []; %option premium/value
%         Intrinsic   = []; %option instrinsic value
%         Delta       = []; %option delta
%         Gamma       = []; %option gamma
%         Rho         = []; %option rho
%         Phi         = []; %option Phi (dividend yield)
%         Vega        = []; %option vega
%         Theta       = []; %option theta
%         Eta         = []; %option eta (elasticity)
%         PayoutTerm  = []; %option terminal payout
        %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function out = digital(obj, varargin)
         % Option Constructor
            if nargin == 0; return;
            else
                out = obj;
                out = populate(out, varargin{:});
            end
           
        end
        
        function out = populate(obj, Exdef, Type, S, X, T, V, R, Q, G)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 6
                error('Required paremeters obj, Exdef, Type, S, X, T');
            end
            if nargin == 6
                R       = []; %interest rate
                Q       = []; %dividend yield
                V       = []; %volatility
                G       = [];
            elseif nargin == 7
                Q       = []; %dividend yield
                R       = []; %volatility
                G       = [];
            elseif nargin == 8
                Q       = []; %volatility
                G       = [];
            elseif nargin == 9
                Q       = []; %volatility
                G       = [];
            else
            end
                
            if any(S <= 0)
                error('Prices must be positive');
            end
            if any(X < 0)
                error('Strikes can not be negative');
            end
            if any(G < 0)
                error('Strikes can not be negative');
            end
            if isempty(V)
                V = zeros(size(S,1));
            end
            if any(V < 0)
                error('Volatilities can not be negative');
            end
            if isempty(R)
                R = zeros(size(S,1));
            end
            if any(R < 0)
                error('Rates can not be negative');
            end
            if isempty(Q)
                Q = zeros(size(S,1), size(S, 2));
            end
            if isempty(G) 
                G = zeros(size(S,1), size(S, 2));
            end
            %make sure Type and Exercise are cell strings
            Type = cellstr(Type);
            Exdef = cellstr(Exdef);
            %Error if dimensions differ
            if ~isequal(size(Type), size(S), size(X), size(G), size(T), ...
                    size(Exdef), size(R), size(Q), size(V));
                [Type, S, V, Exdef, T, X, R, Q, G] = ...
                    gist.gist.scalarexpand(Type, S, V, Exdef, ...
                    T, X, R, Q, G);
            end          
           
            out = obj;
            out.Type    = cellstr(lower(Type)); %call or put
            out.S       = S; %underlying
            out.X       = X; %strike
            out.G       = G; %gap
            out.T       = T; %time to expiry
            out.Exdef   = cellstr(lower(Exdef));
            out.R       = R; %interest rate
            out.Q       = Q; %dividend yield
            out.V       = V; %volatility
            
        end

    end
    
    methods(Static)  %these will be in the specific classes
        %Pricer, greeks, etc
        function obj = calc(obj, param)
            if strcmpi(obj.Typedef, 'con') || ...
                    strcmpi(obj.Typedef, 'cashOrNothing')
                fh = str2func('dcon');
            elseif strcmpi(obj.Typedef, 'gap') || ...
                    strcmpi(obj.Typedef, 'gapOption')
                fh = str2func('pgap');
            elseif strcmpi(obj.Typedef, 'aon') || ...
                    strcmpi(obj.Typedef, 'assetOrNothing')
                fh = str2func('aon');
            else
                error('Invalid option Typedef');
            end
            % add other function handles here
            obj = fh(obj, param);
        end
        
        %out = option.blackscholes(obj, param);

    end
    
end

