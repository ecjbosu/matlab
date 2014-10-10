classdef quotientOption < instruments.option
    %option generic option class to for properties
    %   Generic option class to for properties
    %   Default BlackScholes single asset option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.

        S2   = []; %underlying for the option
        V2   = []; 
        Q2   = [];
        Corr  = [];
        
%         T1   = []; %time to expiry of underlying option
%         UND  = []; %Underlying NPV                   
   end
   properties (SetAccess = protected)
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.
 
       %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function out = quotientOption(obj, varargin)
         % Option Constructor
            if nargin == 0 
               out.Typedef = 'quotientoption'; 
               return;
            else
                out = obj;
                out.Typedef = 'quotientoption';
                out = make(out, varargin{:});
            end
           
        end
        
        function out = make(obj, Exdef, Type, S, S2, X, T, V, V2, Corr, R, Q, Q2)
        %function out = make(obj, Exdef, Type, S, X, X1, T, T1, V, R, Q)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 7
                error('Required paremeters obj, Exdef, Type, S, S2, X, T');
            end
            if nargin == 7 
                R       = []; %interest rate
                Q      = []; %dividend yield
                Q2      = [];
                V       = []; %volatility
                V2      = []; %volatility
                Corr     = [];
            elseif nargin == 8
                Q      = []; %dividend yield
                Q2      = []; 
                R       = []; %volatility
                V2      = []; %volatility
                Corr     = [];
            elseif nargin == 9
                V       = []; %volatility
                V2      = []; %volatility
                Corr     = [];
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
                Q2 = zeros(size(S,1));
            end
%             if any(Q < 0)
%                 error('Dividend Yields can not be negative');
%             end
%             if any(T > T1)
%                 error(['Time to maturity of underlying option must', ...
%                     ' be greater than option on option', ...
%                     num2str(T1),'>',num2str(T)]);
%             end
%             if any(~ismember(Type,{'cc' 'cp' 'pc' 'pp'}'));
%                 error('Invalid option type.  Only cc, cp, pc, pp are valid');
%             end
                
            Type = cellstr(Type);
            Exdef = cellstr(Exdef);
            if ~isequal(size(Type), size(S), size(X), size(T), size(Exdef), ...
                    size(S2), size(V2), size(R), size(Q), size(V), size(Q2), size(Corr));
                [Type, S, S2, V, Exdef, Corr, T, X, R, Q, Q2, V2] = ...
                    gist:.gist.scalarexpand(Type, S, S2, V, Exdef, ...
                    Corr, T, X, R, Q, Q2, V2);
            end
            
            out = obj;
            out.Type    = lower(Type); %call or put
            out.S       = S; %underlying
            out.S2      = S2;
            out.X       = X; %strike
            out.T       = T; %time to expiry
            out.V       = V;  %time to expiry
            out.V2      = V2; %volatility
            out.Exdef   = lower(Exdef);
            out.R       = R; %interest rate
            out.Q       = Q; %dividend yield
            out.Q2      = Q2; %dividend yield
            out.RHO     = Corr; 
        end

    end
    methods(Static)  %these will be in the specific classes
        %Pricer, greeeks, etc
        function obj = calc(obj, param)
            if strcmpi(obj.Typedef, 'quotientoption') || ...
                    strcmpi(obj.Typedef, 'pricer')
                %fh = str2func(strcat('@', 'Geske'));
                fh = str2func('pricer');
            else
                error('Invalid option Typedef');
            end
            % add other function handles here
            obj = fh(obj, param);
            % get underlying option value and greeks

        end  
    end
    
end

