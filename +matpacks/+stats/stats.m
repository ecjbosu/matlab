classdef stats 
%STATS Input/Output functions

% Static Methods
%   FOLDERCHECKCREATE check folder exists
%   Detailed explanation goes here

% Example:
%   matpacks.stats.cov(x)
    methods
        %construction
        function out = stats(obj, varargin)
            
        end
        
    end
    
    methods (Static)
        
        out = psdfix(x, varargin)
        out = cov(x,varargin)
        out = lag(X, laglength, padvalue, direction, axis)
        vargout = GESDoutlier(x,r, alpha)
        
    end

end