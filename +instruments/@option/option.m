classdef option < instruments.forward
    %option generic option class to for properties
    %   Generic option class to for properties
    
   properties
        V       = []; %volatility
        Exdef   = 'european';
        Typedef    = 'blackscholes'; 
                           
   end
   properties (SetAccess = protected)
       
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.
       
        %NPV         = []; %option premium/value
        %Intrinsic   = []; %option instrinsic value
        %Delta       = []; %option delta
        Gamma       = []; %option gamma
        %Rho         = []; %option rho
        %Phi         = []; %option Phi (dividend yield)
        Vega        = []; %option vega
        %Theta       = []; %option theta
        %Eta         = []; %option eta (elasticity)
        %PayoutTerm  = []; %option terminal payout
        %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function out = option(obj, varargin)
         % Option Constructor
            if nargin == 0; return;
            elseif nargin == 1 && isa(varargin{1}, class(obj))
                obj = varargin{1}; %.copy;
            elseif nargin >= 1
                out = obj;
                out = make(out, varargin{1:min(end,8)});
            end
           
        end
        
        function out = make(obj, Exdef, Type, S, T, R, Q, X, V)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 6
                error('Required paremeters obj, Exdef, Type, S, T');
            end
            if nargin == 5
                R       = []; %interest rate
                Q       = []; %dividend yield
                V       = []; %volatility
                X       = [];
            elseif nargin == 6
                V       = []; %volatility
                X       = [];
                Q       = []; %volatility
            elseif nargin == 7
                X       = [];
                V       = []; %volatility
            elseif nargin == 8
                V       = []; %volatility
            else
            end
                
            if any(S <= 0)
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
            if isempty(R)
                R = zeros(size(S,1));
            end
            if any(R < 0)
                error('Rates can not be negative');
            end
            if isempty(Q)
                Q = zeros(size(S,1));
            end
%             if any(Q < 0)
%                 error('Dividend Yields can not be negative');
%             end

            %make sure Type and Exercise are cell strings
            if ~isnumeric(Type)
                Type = cellstr(Type);
            end
            Exdef = cellstr(Exdef);
            
            %Error if dimensions differ
            if ~isequal(size(Type),size(S),size(X),size(T),size(R),size(Q),size(V));
                [Type, S, V, T, X, R, Q] = ...
                    core.scalarexpand(Type, S, V, T, X, R, Q);
            end
            
            out = obj;
            if ~isnumeric(Type);
                Type =  cellstr(lower(Type));
            end
            out.Type    = Type; %call or put
            out.S       = S; %underlying
            out.X       = X; %strike
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
            if strcmpi(obj.Typedef, 'blackscholes') || ...
                    strcmpi(obj.Typedef, 'black') || ...
                    strcmpi(obj.Typedef, 'bs') || ...
                    strcmpi(obj.Typedef, 'asian') % asian is to handle asian default.
                %fh = str2func(strcat('@', 'blackscholes'));
                if ~exist('fh','var')
                    fh = str2func('blackscholes');
                end
            else
                error('Invalid option Typedef');
            end
            
            %make sure all properties are sized equally
            if ~isequal(size(obj.Type), size(obj.S), size(obj.V), ...
                    size(obj.T), size(obj.X), size(obj.R), size(obj.Q))
                
                [Type, S, V, T, X, R, Q] ...
                    = core.scalarexpand(obj.Type, obj.S, ...
                    obj.V, obj.T, obj.X, obj.R, obj.Q);
                
                obj.Type = Type; obj.S = S; obj.V = V; obj.T = T; obj.X = X; 
                obj.R = R; obj.Q = Q;
                
            end
                        
                        
                        % add other function handles here
            obj = fh(obj, param);
            %if length(obj) == 1
                %repackage single obj
            %    obj = obj{1};
            %end
        end
        
        out = option.blackscholes(obj, param);

    end
    
end

