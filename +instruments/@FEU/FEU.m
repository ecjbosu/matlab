classdef FEU < instruments.option
    %option generic option class to for properties
    % see also instruments.option
    
    methods
        function out = FEU(obj, varargin)
         % Option Constructor
            if nargin == 0; return;
            elseif nargin == 1 && isa(varargin{1}, class(obj))
                obj = varargin{1}; %.copy;
            elseif nargin >= 1
                out = obj;
                out = make(out, varargin{1:min(end,8)});
            end
           
        end
     end
%     
 end
 
