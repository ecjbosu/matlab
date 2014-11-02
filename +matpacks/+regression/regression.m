classdef regression < matpacks.stats
%REGRESSION generic class to wrap up Matlab functions

properties
        Y = [];
        X = [];
        Xnames = [];
        Alpha = .05;
    end
    
    properties (SetAccess = protected)
        
        Parameters  = Make_Parm_Struct;
        CovP        = [];
        Residuals   = [];
        ResidCI     = [];
        Stats       = Make_Stat_Struct;
        
    end
      
    methods 
        %constructor
        function out = regression(obj, varargin)
            
        end
        
        function Pvalue(obj, df)
            if nargin < 2 || isempty(df)
                df = length(~isnan(obj.Y)) - numel(obj.Parameters.Parameter);
            end
            
            if ~isempty(obj.Parameters.TStat)
                tstat = obj.Parameters.TStat;
            else
                tstat = obj.Parameters.Parameter ./ obj.Parameters.SE;
            end
            
            obj.Parameters.Pval  = tcdf(-abs(tstat), df)*2;
            
        end
        
        function out = model(obj)
            % put resgress estimation and result population here.
            %[hat, bint, r, rint, stats] = %regress(estmat.Y,estmat.X,.05);reg
            [obj.Parameters.Parameter, obj.Parameters.CI, ...
                obj.Residuals, obj.ResidCI, eststats] = ...
                regress(obj.Y, obj.X, obj.Alpha);
            out.MSE         = eststats(4);
            out.RSquared    = eststats(1);
            out.FValue      = eststats(2);
            out.FProb       = eststats(3);

        end
        function Tstat(obj, HYP)
            if nargin < 2 || isempty(HYP)
                HYP = 0;
            end
            
            obj.Parameters.TStat = (obj.Parameters.Parameter - HYP) ./ obj.Parameters.SE;
            
        end
        
        function SE(obj)
            if ~isempty(obj.CovP)
                obj.Parameters.SE = diag(obj.CovP);
            else
                obj.Parameters.SE = nans(numel(obj.Parameters.Parameter),1);
            end
        end
   end

    methods (Static)
        
        
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = Make_Parm_Struct

            out.Parameter   = [];
            out.SE          = [];
            out.TStat       = [];
            out.Pval        = [];
            out.CI          = [];
            
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = Make_Stat_Struct

            out.MSE         = [];
            out.RSquared    = [];
            out.AdjRSquared = [];
            out.FValue      = [];
            out.FProb       = [];
            
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%