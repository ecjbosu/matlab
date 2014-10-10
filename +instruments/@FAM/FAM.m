classdef FAM < instruments.option
    %option generic option class to for properties
    %   See instruments.option
     methods
        function out = FAM(obj, varargin)
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
 
