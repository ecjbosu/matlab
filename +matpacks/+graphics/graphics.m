classdef graphics 
%elmat Matrix elemental manipulators
% Static Methods
%rotateXLabels: rotate any xticklabels
      
    methods (Static)
        
        out = rotateXLabels( ax, angle, varargin );
        hText = xticklabel_rotate(XTick,rot,varargin);
        par=mtit(varargin)
        
    end

end