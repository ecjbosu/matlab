classdef ETL < connectors.JDBC
    %ETL extacts or loads from a datasource
    %   

    properties %(SetAccess = public, GetAccess = public, Dependent)
        
        MarkDate    = []; % business date
        days        = 90; % history
        dirPath     = []; % location to export postions cache
        etlhandle   = 'finsealcurves'; 
        fetchtype = 1;  %fetch method to use 1 = fetchfaststring
                                            %0 = fetchfast
                                         
    end
    
    properties (SetAccess = private, GetAccess = public)
        
        dirStatus    = []; % data link object
        
    end
  
    methods
        
        function obj = ETL( varargin )
        %ETL constructor
    
            if nargin == 0 

                return 

            elseif nargin == 1 && isa(varargin{1}, class(obj))

                obj = varargin{1}; %.copy;

            elseif nargin >= 1

                obj = obj.populate(varargin{:});

            end
        
        end
        
        function obj = populate( varargin )

            %POPULATE Populates a ETL Object

            %   Parse Inputs and populate object

            if nargin < 7 % JDBC takes 6 parms but obj is implicit defined    

                error('Missing required inputs:  user, passwd, url, port, db, schema');
                
            end
            
            obj = varargin{1};
            
            obj= obj.populate@dataconnect.JDBC(varargin{2:7});
           
            
            if nargin >= 8 % MarkDate
                
                if ischar(varargin{8})
                
                    obj.MarkDate = datenum(varargin{8});
                    
                elseif isnumeric(varargin{8})
                    
                    obj.MarkDate = varargin{8};
                    
                else
                    
                    error('MarkDate parameter has unknown data type');
                    
                end
                
            end
            if nargin >=9 
                
               if ~isnumeric(varargin{9})
                   
                   error('days must be numeric');
                   
               else
                   
                   obj.days = varargin{9};
                   
               end
               
            end
            
            if isempty(obj.MarkDate) 
                
                obj.MarkDate =  getSystemMarkDate(obj, obj.days);
                
            else
                
                t1 = getSystemMarkDate(obj, obj.days);
                
            end
            
            if nargin >= 10 %dirpath
                
                if ~ischar(varargin{10})
                    
                    error('dirpath must be a charater or cellstr');
                    
                else
                    
                    % ensure cellstr
                    obj.dirPath = fullfile(varargin{10}, ...
                        datestr(obj.MarkDate,'yyyymmdd'));
                    % folderCheckCreate should be converted to logger and
                    % this through a warning
                    obj.dirStatus = folderCheckCreate( char(obj.dirPath) );                   
                    
                end 
                
            end
            
            if nargin == 11 %ETLhandle to retrieve
                
                if ~isempty(varargin{11})
                    
                    if ~ischar(varargin{11})
                        
                        error('ETLhandle must be a charater or cellstr');
                        
                    else
                        
                        % ensure cellstr
                        obj.etlhandle = varargin{14};
                        
                    end
                    
                end
                
            end
                    
        end
        
        function out = getSystemMarkDate(obj, days)
        %getSystemMarkDate will retreive the current MarkDate date from the system
        
            error('gist:ETL:getSystemMarkDate: is not functional');
            
        end
        
        function obj = retrieve(obj, varargin)
            % retrieve the data using the connection
            
            if ~isempty(obj.etlhandle)
                
                fh = str2func( obj.etlhandle );
                
            end
            
            if isempty(obj.etlhandle)
                
                %do nothing
                
            elseif numel(varargin) == 0
                
                obj.SQL = fh( obj.sbu, datestr(obj.MarkDate, 'dd-mmm-yyyy'));
                
            else 
                
                obj.SQL = fh(obj, varargin{1:end});
                
            end
            
            if obj.fetchtype == 1
                
                obj = fetchDataString(obj);
                
            elseif obj.fetchtype == 2
                
                obj = fetchFast(obj);
                
            else
                
                obj = fetchFast(obj);
                                
            end
                
        end
        
        function out = dswrite(obj, type)
            %dswrite write out the cache data
            
            out = false;
            
            if isempty(gist.environment.validfiletypes(type))
                
                error('Incorrect export type.  type must be xls? or csv');
                
            end
            
            %check for empty option data
            idx = false;
            
            if size(obj, 1) == 1
                
                a = cellstr(obj.data.Properties.VarNames(:));
                idx = all( cellfun(@(x) (isempty(obj.data.(char(x)))), a));
                
            end
            
            if ~idx

                %write out an empty file for a placeholder
                writeds(obj, type);
                out = true;
                
            else
                
                warning('gist.ETL: %s.','Empty data retrieval for caching');
                
            end
        
        end
        
        function out = writeds(obj, type)
            %writeds is the helper method to do the export
            
            out = false;
            type = cellstr(type); % ensure strings
            if strcmpi(type, 'csv')
                
                export(obj.data,'file', ...
                    fullfile(obj.dirPath, ...
                    char(strcat(strrep(obj.sbu,' ','_'), '_', ...
                    obj.etlhandle, '.csv'))),'delimiter',',');
                out = true;
                
            elseif strcmpi(type, 'xls')
                
                export(obj.data,'XLSfile',fullfile(obj.dirPath, ...
                     char(strcat(obj.sbu, '_', obj.etlhandle, '.xls'))));
                out = true;
                
            else
                
                 error('Incorrect export type.  type must be xls or csv');
                 
            end   
        end
        
    
    end
    
    methods (Static)
        
        
    end
end