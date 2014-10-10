classdef asian < instruments.option
    %Asian option class to for properties
    %   Generic option class to for properties
    %   Default Turnbull Wakeman Asian option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.
    %   Key is the function/class handle for that will facilitate
    %   overloading option classes and methods

    properties
        SA = [];
        T2 = [];
        N  = []; % number of fixings remaining or time between fixings
                 % not implemented at this time.
                           
   end
   properties (SetAccess = protected)
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.

       %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function obj = asian(obj, varargin)
         % Option Constructor
            obj.Typedef = 'asian'; 
            if nargin == 0 
               return;
            elseif nargin == 1 && isa(varargin{1}, class(obj))
                obj = varargin{1}; %.copy;
            elseif nargin >= 1
                obj = obj.populate(varargin{:});
            end
           
        end
        
        function out = populate(obj, Exdef, Type, S, SA, X, T, T2, V, R, Q)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 8
                error('Required paremeters obj, Exdef, Type, S, SA, X, T, T2');
            end
            if nargin == 8
                R       = []; %interest rate
                Q       = []; %dividend yield
                V       = []; %volatility
            elseif nargin == 9
                Q       = []; %dividend yield
                R       = []; %volatility
            elseif nargin == 10
                Q       = []; %volatility
            else
            end
                
            if any(S <= 0)
                error('Prices must be positive');
            end
            if any(SA < 0)
                error('Average Prices must be positive');
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
            if any(Q < 0)
                error('Dividend Yields can not be negative');
            end
            if any(T2 < 0)
                error('Averaging Time can not be negative');
            end
            Type = cellstr(Type);
            Exdef = cellstr(Exdef);
            if ~isequal(size(Type), size(S), size(X), size(T), ...
                    size(T2), size(Exdef), size(R), size(Q), size(V));
                [Type, S, V, Exdef, T, X, R, Q, T2] = ...
                    gist.gist.scalarexpand(Type, S, V, Exdef, ...
                    T, X, R, Q, T2);
            end
            
            out = obj;
            out.Type    = lower(Type); %call or put
            out.S       = S; %underlying
            out.SA      = SA;
            out.X       = X; %strike
            out.T       = T; %time to expiry
            out.T2      = T2;
            out.Exdef   = lower(Exdef);
            out.R       = R; %interest rate
            out.Q       = Q; %dividend yield
            out.V       = V; %volatility
        end
    end
    
    methods(Static)  %these will be in the specific classes
        %Pricer, greeks, etc
        function obj = calc(obj, param)
            if strcmpi(obj.Typedef, 'asian') || ...
                    strcmpi(obj.Typedef, 'turnbullwakeman') || ...
                    strcmpi(obj.Typedef, 'aon') || ...
                    strcmpi(obj.Typedef, 'con') 
                    
%                fh = str2func(strcat('@', 'TurnbullWakeman'));
                fh = str2func('TurnbullWakeman');
            end
            % add other function handles here
            obj = fh(obj, param);
        end  
    end
    
end
