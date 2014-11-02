classdef forward < instruments.instruments
    %generic forward class to for properties
    %   Generic forward class to for properties
    %   Key is the function/class handle for that will facilitate
    %   overloading option classes and methods
    
   properties
       
        Type    = 'swap'; %Notes: Type defs need to be defined.  
                                  %This is the base forward, futures, swap
                                  %instrument
        S       = []; %underlying
        X       = []; %strike
        T       = []; %time to expiry
        R       = []; %interest rate
        Q       = []; %dividend yield
                           
   end
   properties (SetAccess = protected)

        NPV         = []; %option premium/value
        Intrinsic   = []; %option instrinsic value
        Delta       = []; %option delta
        Rho         = []; %option rho
        Phi         = []; %option Phi (dividend yield)
        Theta       = []; %option theta
        Eta         = []; %option eta (elasticity)
        PayoutTerm  = []; %option terminal payout

   end
   
    methods
        function out = forward(obj, varargin)
         % Option Constructor
            if nargin == 0; return;
            else
                
                out = obj;
                out = make(out, varargin{:});
                
            end
           
        end
        
        function out = make(obj, Type,  S, T, R, Q, X)
            %Make option object
            % Required paremeters obj, Exdef, Type, S, X, T
            if nargin < 5
                
                error('Required paremeters obj, Type, S, X, T');
                
            end
            if nargin == 5
                
                R       = []; %interest rate
                Q       = []; %dividend yield
                
            elseif nargin == 6
                
                Q       = []; %dividend yield
                
            end
                
            if any(S <= 0)
                warning('Prices should be positive');
            end
            if any(X < 0)
                warning('Strikes should not be negative');
            end
            if isempty(R)
                R = NaN(size(S,1));
            end
            if any(R < 0)
                error('Rates can not be negative');
            end
            if isempty(Q)
                Q = NaN(size(S,1),size(S,2));
            end
            
            %makse sure Type and Exercise are cell strings
            Type = cellstr(Type);
 
            %Error if dimensions differ
            if ~isequal(size(Type),size(S),size(X),size(T),size(R),size(Q));
                [Type, S, T, X, R, Q] = ...
                    core.scalarexpand(Type, S, T, X, R, Q);

            end
            
            out = obj;
            out.Type    = cellstr(lower(Type)); %call or put
            out.S       = S; %underlying
            out.X       = X; %strike
            out.T       = T; %time to expiry
            out.R       = R; %interest rate
            out.Q       = Q; %dividend yield
            
        end

    end
    
    methods(Static)  %these will be in the specific classes
        %Pricer, greeks, etc
        function obj = calc(obj, param)
            fh = str2func('pricer');
            % add other function handles here
            obj = fh(obj, param);
        end
        
    end
    
end

