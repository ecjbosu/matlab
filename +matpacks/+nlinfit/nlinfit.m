classdef nlinfit < matpacks.regression
%NLINFIT class to wrap up Matlab nlinfit function

%
% 

    properties
        equation = [];
        Init0    = [];
        
    end
    
    properties (SetAccess = protected)
        
        J = [];
        
    end

    methods
        %constructor
        function out = nlinfit(obj, varargin)
            
        end
       
        function CI(obj, type)
        
            if nargin < 2 || isempty(type);     type = 'Jacobian';      end
            
            obj.Parameters.CI = nlparci(obj.Parameters.Parameter, obj.Residuals, type, obj.J);
            
        end
        
        function model( obj )
            if isempty(obj.X) || isempty(obj.Y) 
                error('matpacks:stats:nlinfit:model: %s', ...
                    'Dependent and Independent variables must be specified');
            end
            
            [obj.Parameters.Parameter, obj.Residuals,obj.J, obj.CovP, ...
                obj.Stats.MSE] = nlinfit(obj.X, obj.Y, obj.equation, obj.Init0);

        end
        function regStats(obj)
            if isempty(obj.X) || isempty(obj.Y) || isempty(obj.Residuals) ...
                    || isempty(obj.Parameters.Parameter)
                error('matpacks:stats:nlinfit:model: %s', ...
                    'Dependent and Independent variables must be specified');
            end
            %move to regress methods
            p           = numel(obj.Parameters.Parameter);
            y           = obj.Y;
            x           = obj.X;
            r           = obj.Residuals;
            n = length(obj.Y);
            
            % remove NaN's
            wasnan      = (isnan(obj.Y) | any(isnan(obj.X), 2));
            havenans    = any(wasnan);
            if havenans
                y(wasnan) = [];
                x(wasnan, :) = [];
                r(wasnan) = [];
                n = length(y);
            end
            nu      = max(0, n - p);
            yhat    = x * obj.Parameters.Parameter;
            normr   = norm(r);
            
            SSE             = normr.^2;
            RSS             = norm(yhat - mean(y))^2;
            TSS             = norm(y - mean(y))^2;
            obj.Stats.RSquared    = 1 - SSE/TSS;
            obj.Stats.FValue      = (RSS / (p-1)) / obj.Stats.MSE;
            %calc Fvalue pvalue see fpval.m in toolbox/stats/stats/private
            obj.Stats.FProb       = fcdf(1/obj.Stats.FValue, p-1, nu);
            obj.Stats.AdjRSquared = 1 - (1- obj.Stats.RSquared) * (n -1) / (n - p - 1);
            
        end
        function [out] = disp(obj)
%             out = obj.Xnames';
%             %out = dataset(
            for i = 1:numel(obj)
                disp('Model Estimates')
                disp(obj(i).dispEst)
                disp('Model Fit Statistics')
                disp(obj(i).dispRegStats)
            end
            %out.CI          = [];

        end
        
        function [out, title] = dispEst(obj)
            
            out = obj.Xnames';
            out = [out num2cell([obj.Parameters.Parameter obj.Parameters.SE ...
                obj.Parameters.TStat obj.Parameters.Pval])];
            title = {'Independent Vars' 'Param Est.' 'Std Error' 'T-Stat' 'Prob T'};
            if nargout == 1
                out = [title; out];   
            else
                out = out;
                title = title;
            end
            
        end
         function [out, title] = dispRegStats(obj)
            
            out = num2cell([obj.Stats.MSE; obj.Stats.RSquared; obj.Stats.AdjRSquared; ...
                obj.Stats.FValue; obj.Stats.FProb]);
            title = {'MSE'; 'RSquared'; 'AdjRSquared'; 'F-Value'; 'Prob F'};
            if nargout == 1
                out = [title, out];   
            else
                out = out;
                title = title;
            end
        end
   end
    methods (Static)
        
        
    end

end