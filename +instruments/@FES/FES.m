classdef FES < instruments.spreadOption
    %option generic option class to for properties
    %   Generic option class to for properties
    %   Default BlackScholes single asset option is configured 
    %   Option types for single asset or multi asset inherit these
    %   properties.
    %   Key is the function/class handle for that will facilitate
    %   overloading option classes and methods
    %
%    Based on Spreadoption model from The complete guide to option pricing
%    formulas pp 213-214 and Exotic Options Chatper 22 pp 489 - 499
%  Result Paramters:
%       All
%       Price/Premium
%       Delta, Gamma, Vega, Theta, Rho, Psi, Eta
%  Example:
%   import instruments.*
%   a=spreadoption(option,repmat('American',5,1),repmat('p',5,1),repmat(10,5,1), ...
%    repmat(10,5,1),repmat(.5,5,1),repmat(.2,5,1),repmat(.03,5,1),repmat(0,5,1))
%   a = a.optioncalc(a,'NPV')
%   a = a.optioncalc(a,'delta') 
%   a = a.optioncalc(a,'vega')
%   a = a.optioncalc(a,'Gamma')
%   a = a.optioncalc(a,'theta')
%   a = a.optioncalc(a,'RHO')
%   a = a.optioncalc(a,'all')

%TODO : 1 Psi and Eta   
%       2 Intrinsic calculation and 
%       3 Vol time adjustment for Vol see Hull and Haug
%       4 Add functionality to accept a dataset or struct with the
%       appropriate field/VarNames. Modify the constuctor to get this feature.
%       5 Add underlying option NPV and greeks to UND property
    
   properties
        %BO   = []; % volume of the first leg
        
   end
   properties (SetAccess = protected)
   
   end
   
    methods
        function out = FES(obj, varargin)
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
    end
end

