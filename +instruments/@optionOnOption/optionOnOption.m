classdef optionOnOption < instruments.option
    %option generic option class to for properties
    %   Generic option class to for properties
    %   Default BlackScholes single asset option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.


    
   properties
       
        X1   = []; %underlying strike for the option
        T1   = []; %time to expiry of underlying option
        UND  = []; %Underlying NPV                   
        
   end
   properties (SetAccess = protected)
       % these are set access private from the class only.  The NPV will
       % have the ability to be set from the IV calculator but never by the
       % user.  All others can only be updated by the class performing the
       % calculations.
 
       %Notes: Higher order greeks will be implemented in the future
    end
   
    methods
        function out = optionOnOption(obj, varargin)
         % Option Constructor
            if nargin == 0 
               out.Typedef = 'optiononoption'; 
               out.UND = instruments.option;
               return;
            else
               out = obj;
               out.Typedef = 'optiononoption';
               out.UND = instruments.option;
               out = make(out, varargin{:});
            end
           
        end
        
        function out = make(obj, Exdef, Type, S, X, X1, T, T1, V, R, Q)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 7
                error('Required paremeters obj, Exdef, Type, S, X, X1, T, T1');
            end
            if nargin == 7
                R       = []; %interest rate
                Q       = []; %dividend yield
                V       = []; %volatility
            elseif nargin == 8
                Q       = []; %dividend yield
                R       = []; %volatility
            elseif nargin == 9
                Q       = []; %volatility
            else
            end
                
            if any(S <= 0)
                error('Prices must be positive');
            end
            if any(X < 0)
                error('Strikes can not be negative');
            end
            if any(X1 < 0)
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
            if any(T > T1)
                error(['Time to maturity of underlying option must', ...
                    ' be greater than option on option', ...
                    num2str(T1),'>',num2str(T)]);
            end
            if any(~ismember(Type,{'cc' 'cp' 'pc' 'pp'}'));
                error('Invalid option type.  Only cc, cp, pc, pp are valid');
            end
                
            Type = cellstr(Type);
            Exdef = cellstr(Exdef);
            if ~isequal(size(Type), size(S), size(X), size(T), size(Exdef), ...
                    size(X1), size(T1), size(R), size(Q), size(V));
                [Type, S, V, Exdef, T, T1, X, X1, R, Q] = ...
                    gist:.gist.scalarexpand(Type, S, V, Exdef, ...
                    T, T1, X, X1, R, Q);
            end
            
            out = obj;
            out.Type    = lower(Type); %call or put
            out.S       = S; %underlying
            out.X       = X; %strike
            out.X1      = X1;
            out.T       = T; %time to expiry
            out.T1      = T1; %time to expiry
            out.Exdef   = lower(Exdef);
            out.R       = R; %interest rate
            out.Q       = Q; %dividend yield
            out.V       = V; %volatility
            %Make the UND
            out.UND.S   = S;
            out.UND.X   = X;
            out.UND.R   = R;
            out.UND.T   = T1;
            out.UND.Q   = Q;
            out.UND.V   = V;
            Type = lower(char(Type));
            out.UND.Type = Type(:,2);
            
        end

    end
    methods(Static)  %these will be in the specific classes
        %Pricer, greeeks, etc
        function obj = calc(obj, param)
            if strcmpi(obj.Typedef, 'optiononoption') || ...
                    strcmpi(obj.Typedef, 'Geske')
                %fh = str2func(strcat('@', 'Geske'));
                fh = str2func('Geske');
            else
                error('Invalid option Typedef');
            end
            % add other function handles here
            obj = fh(obj, param);
            % get underlying option value and greeks
            
            if length(obj) == 1
                %repackage single obj
                obj = obj{1};
            end
            obj.UND = obj.UND.optioncalc(obj.UND, param);
            %if T<0 move UND up to option
            indx = (obj.T<0);
            if ~isempty(indx)
                obj.NPV(indx)         = obj.UND.NPV(indx); %option premium/value
                obj.Delta(indx)       = obj.UND.Delta(indx); %option delta
                obj.Gamma(indx)       = obj.UND.Gamma(indx); %option gamma
                obj.Rho(indx)         = obj.UND.Rho(indx); %option rho
        %        out.Phi(indx)         = temp.Phi(indx); %option Phi (dividend yield)
                obj.Vega(indx)        = obj.UND.Vega(indx); %option vega
                obj.Theta(indx)       = obj.UND.Theta(indx); %option theta
        %        out.Eta(indx)         = obj.UND.Eta(indx);
                obj.Intrinsic(indx)   = obj.UND.Intrinsic(indx);
                obj.PayoutTerm(indx)  = obj.UND.PayoutTerm(indx);
            end
            
        end  
    end
    
end

