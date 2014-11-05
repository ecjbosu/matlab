classdef connector 
    %Connection class
    %   Generic Connection clsass for interal databases using the Database 
    
    properties
        url     = []; 
        port    = []; 
        db      = [];
        schema  = [];
        props   = [];
        drv     = [];
        conn    = [];
        SQL     = [];
    end
    
    properties (SetAccess = protected)
        
        data    = {};
        
    end
    
    methods
        
        function obj = connector(varargin)
             
        end
        
    end
    
end

