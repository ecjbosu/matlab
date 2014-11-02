classdef spreadOption < instruments.option
    %option generic option class to for properties
    %   Generic option class to for properties
    %   Default BlackScholes single asset option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.

   properties
        S2   = []; %price of the second leg
        V2   = []; % vol of the second leg
        Corr  = []; % Correlation between two legs
        Q2   = []; % volume of the second leg %renamed to Q from B
        B    = [];
        B2   = [];
       %removed all properties inherited from option
        %X1   = []; %underlying strike for the option
        %T1   = []; %time to expiry of underlying option
        %SO   = []; %price of the first leg
        %VO   = []; % vol of the first leg
        %BO   = []; % volume of the first leg
        
   end
   properties (SetAccess = protected)
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.
%         Delta2       = []; %option delta
%         Gamma2       = []; %option gamma
%         Vega2        = []; %option vega
        %Rho          = []; %option correlation greek
        %Notes: Higher order greeks will be implemented in the future
 
       %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function out = spreadOption(obj, varargin)
         % Option Constructor
            if nargin == 0 
               out.Typedef = 'spreadoption'; 
               return;
            else
               out = obj;
               out.Typedef = 'spreadoption';
               out = make(out, varargin{:});
            end
           
        end
        
        function out = make(obj, Exdef, Type, S, T, R, Q, X, V, ...
                S2, V2, Q2, Corr, B, B2)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
% TODO  : Modify the input conditions
            if nargin < 15
                error('Required paremeters obj, Exdef, Type, S, S2, V, V2, Corr, T, R, B, B2');
            end
            if nargin == 5
                R       = []; %interest rate
                Q       = []; %dividend yield
                X       = []; %strike
                V       = []; %volatility
                V2      = []; %volatility
                Q2      = []; %dividend yield
                B       = []; %volatility
                B2      = []; %dividend yield
                Corr    = []; %dividend yield
            elseif nargin == 6
                X       = []; %strike
                V       = []; %volatility
                V2      = []; %volatility
                Q       = []; %dividend yield
                Q2      = []; %dividend yield
                B       = []; %volatility
                B2      = []; %dividend yield
                Corr    = []; %dividend yield
            elseif nargin == 7
                X       = []; %strike
                V       = []; %volatility
                V2       = []; %volatility
                Q       = []; %dividend yield
                Q2       = []; %dividend yield
                B       = []; %volatility
                B2       = []; %dividend yield
                Corr       = []; %dividend yield
            elseif nargin == 10
                Q       = []; %dividend yield
                Q2       = []; %dividend yield
                B       = []; %volatility
                B2       = []; %dividend yield
                Corr       = []; %dividend yield
            elseif nargin == 11
                Q2       = []; %dividend yield
                B       = []; %volatility
                B2       = []; %dividend yield
                Corr       = []; %dividend yield
            elseif nargin == 12
                B       = []; %volatility
                B2       = []; %dividend yield
                Corr       = []; %dividend yield
            elseif nargin == 13
                B2       = []; %dividend yield
                Corr       = []; %dividend yield
            elseif nargin == 14
                Corr       = []; %dividend yield
            else
           end
                
            if any(S <= 0)
                error('Prices must be positive');
            end
            if any(S2 <= 0)
                error('Prices must be positive');
            end
            if any(X < 0)
                error('Strikes can not be negative');
            end
            if isempty(V)
                V = zeros(size(S,1));
            end
            if any(V < 0)
                error('Volatilities can not be negative');
            end
            if isempty(V2)
                V2 = zeros(size(S,1));
            end
            if any(V2 < 0)
                error('Volatilities can not be negative');
            end
            if isempty(R)
                R = zeros(size(S,1));
            end
            if any(R < 0)
                error('Rates can not be negative');
            end
            if isempty(Q)
                Q = zeros(size(S,1));
            end
            if isempty(Q2)
                Q = zeros(size(S,1));
            end
            if any(Q < 0)
                error('Dividend Yields can not be negative');
            end
            if any(Q2 < 0)
                error('Dividend Yields can not be negative');
            end
            if isempty(B)
                B = ones(size(S,1));
            end
            if isempty(Q2)
                B2 = ones(size(S,1));
            end
            if any(B < 0)
                error('Asset multiplier on Asset 1 can not be negative');
            end
            if any(B2 < 0)
                error('Asset multiplier on Asset 1 can not be negative');
            end
            if any(~ismember(lower(Type),{'c' 'p'}'));
                error('Invalid option type.  Only c p are valid');
            end
                
            %ensure cellstr
            if ~isnumeric(Type)
                Type = cellstr(Type);
            end
            
            Exdef = cellstr(Exdef);
            
            %make sure all properties are sized equally
            if ~isequal(size(Type), size(S), size(S2), size(V), ...
                    size(Corr), size(T), size(X), size(R), size(Q), ...
                    size(B), size(B2), size(Q2), size(V2));
                [Type, S, S2, V, Corr, T, X, R, Q, B, B2, Q2, V2] ...
                    = core.scalarexpand(Type, S, S2, V, ...
                    Corr, T, X, R, Q, B, B2, Q2, V2);
            end
             
            out = obj;
            out.Type    = lower(Type); %call or put
            out.S       = S; % First underlying
            out.S2      = S2; % Second underlying
            out.X       = X; %strike
            out.T       = T; %time to expiry
            out.Exdef   = lower(Exdef);
            out.R       = R; %interest rate
            out.V       = V; % first volatility
            out.V2      = V2; % second volatility
            out.Corr     = Corr; % Correlation between two
            out.Q       = Q;
            out.Q2      = Q2;
            out.B       = B;
            out.B2      = B2;

        end

    end
    methods(Static)  %these will be in the specific classes
        %Pricer, greeeks, etc
        function obj = calc(obj, param)
            if strcmpi(obj.Typedef, 'spreadoption') || ...
                    strcmpi(obj.Typedef, 'kirkApprox')
                
                %hack to clear fh if exists 
                if ~exist('fh','var'); 
                   fh = str2func(strcat('@','kirkApprox'));
                end
            else
                error('Invalid option Typedef');
            end
            
            % check size obj properties
            if ~isequal(size(obj.Type), size(obj.S), size(obj.S2), ...
                    size(obj.V), size(obj.Corr), ...
                    size(obj.T), size(obj.X), size(obj.R), size(obj.Q), ...
                    size(obj.B), size(obj.B2), size(obj.Q2), size(obj.V2))
                
                [Type, S, S2, V, Corr, T, X, R, Q, B, B2, Q2, V2] = ...
                    core.scalarexpand(obj.Type, obj.S, ...
                    obj.S2, obj.V, obj.Corr, obj.T, obj.X, ...
                    obj.R, obj.Q, obj.B, obj.B2, obj.Q2, obj.V2);
                
                obj.Type = Type; obj.S = S; obj.S2 = S2; obj.V = V;
                obj.Corr = Corr; obj.T = T; obj.X = X; obj.R = R;
                obj.Q = Q; obj.B = B; obj.B2 = B2; obj.Q2 = Q2; obj.V2 = V2;
            end
            
            % add other function handles here
            obj = fh(obj, param);

            
            % get underlying option value and greeks
            
            if length(obj) == 1
                %repackage single obj
                obj = obj{1};
            end
        end  
    end
    
end

