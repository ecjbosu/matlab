classdef JDBC < connectors.connector
    %JDBC Connection class
    %   JDBC Connection connects to interal databases using the Database 
    %   Java package.  
    
    properties
        
        databaseSource = 'MySQL';  %database source for java connector: MySQL or Oracle
        
    end
    
    methods
        
        %constructor    
        function obj = JDBC( varargin )
            
            if nargin == 0 
                return 
            
            elseif nargin == 1 && isa(varargin{1}, class(obj))
                obj = varargin{1}.copy; 
            
            elseif nargin >= 1
                obj = obj.populate( varargin{:} );
            
            end
                        
        end
        
        
        function obj = populate( varargin )
            
            obj = varargin{1};
            
            if nargin < 2 || isempty(varargin{2})    
                user   = ''; 
            else
                user = varargin{2};
            end
            
            if nargin < 3 || isempty(varargin{3})    
                passwd = '';
            else
                passwd = varargin{3};
            end
            
            if nargin < 4 || isempty(varargin{4})
                obj.url = []; 
            else
                obj.url = varargin{4}; %url
            end

            if nargin < 5 || isempty(varargin{5})
                obj.port = [];
            else 
                obj.port = varargin{5}; %port;
            end

            if nargin < 6 || isempty(varargin{6})
                obj.db = []; 
            else
                obj.db = varargin{6}; %db;
            end
            
            if nargin < 7 || isempty(varargin{7})
                obj.schema = [];
            else
                obj.schema = varargin{7}; %schema;
            end
            
            if nargin < 8 || isempty(varargin{8})
                obj.databaseSource = 'MySQL';
            else
                obj.databaseSource = varargin{8};
            end
            
            %set up a Properties object for the connection
            if ~isempty(user) && ~isempty(passwd)

                obj.setprops(user, passwd);

            end
            
            %set the driver and default connection;
            obj.setDriver;
            
            %make the connections
            % add code to set up the JDBC class and add a connnect method
            % when this is not executed at initialization
            if ~isempty(obj.drv)

                obj.open;
                
            end
            
        end
        
        %close connection and reset to default
        function obj = close(obj)
            
            obj.conn.close;
            obj.conn = []; %res
            
        end
        
        %open connection if all properties set or reopen a previously
        %closed connection
        function obj = open(obj)
            
            %make the connections
           
            if nargin == 1 && ~isempty(obj.databaseSource)
                
                if ~connectors.connector.JDBC.validdatabaseSource(obj.databaseSource);
                    error('connectors:connector:JDBC:setDriver: %s', 'invalid datasource');
                end
               
                dsfh = str2func( [mfilename('class') '.' obj.databaseSource]);
                
                obj.conn = dsfh(obj, 'open');

            end;

%             fullurl=strcat('"jdbc:oracle:thin:@',obj.url,':', num2str(obj.port),'/',obj.db);
%             obj.conn = obj.drv.connect(fullurl, obj.props);
            
        end
        
        function obj = setprops(obj, user, passwd)
            
            %set up a Properties object for the connection
            
            import java.util.Properties.*;
            
            obj.props=java.util.Properties;
            obj.props.put ('user', user);
            obj.props.put ('password', passwd);
            
        end    
        
        function out = setDriver( obj, drv )
            
            
            if nargin < 2 || isempty(drv) && ~isempty(obj.databaseSource)
                
                if ~connector.JDBC.validdatabaseSource(obj.databaseSource);
                    error('connectors:connector:JDBC:setDriver: %s', 'invalid datasource');
                end
               
                dsfh = str2func( [mfilename('class') '.' obj.databaseSource]);
                
                drv = dsfh(obj, 'drv');

            end;

            out = 1;
            
            try
                obj.drv = drv;
            catch EX
                if narout > 0 
                    out = EX;
                else
                    warning(EX.message);
                end
            end
            
        end
        
    end
    
    methods (Static)
        
        out = validdatabaseSource( obj )
        out = MySQL(obj, in )
        out = Oracle(obj, in )
        out = MSSQL(obj, in )
        
    end
end

