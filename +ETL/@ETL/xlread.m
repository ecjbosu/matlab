function out = xlread( obj, source, varargin )
%XLREAD ETL xlread
%   Source is the source script hannle name
%   varargin will be 
%


    %   Parse Inputs

    if nargin < 1 || isempty(source);    error('Missing required soruce input');  end
    %add if source empty then read dataset using parsed vargin.  or if
    %source function does not exist
    
    if ~isa(source, 'char')
        source = char(source);
    end
    

    %   Ensure Cellstr

    fh = str2func(source);
    
    try
        
        out = fh(obj, varargin{:});
        
    catch ME
        
        disp(ME.message);
        out = ME;
        
    end

end
