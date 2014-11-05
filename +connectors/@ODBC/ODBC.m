classdef ODBC < connectors.connector
    %ODBC Connection class
    %   ODBC Connection that connects to a databuase using ODBC 
    %     
 
    properties
    end
    
    methods
        %constructor    
        function obj = ODBC(user, passwd, url, port, db, schema )
            
            if ~isdeployed
                import oracle.jdbc.driver.OracleDriver;
                import java.util.Properties;
            end            
            
            if nargin <=  2
                obj.url = ''; %'tns_rgent02dev.am.ist.bp.com';
                obj.port = []; %1502;
                obj.db = '';
                obj.schema = '';
                %dologin;  % fix this for no user/password;
            end
            
            obj.props=java.util.Properties;
            obj.props.put ('user', user);
            obj.props.put ('password', passwd);

            %set the driver and default connection;
            
            drv=oracle.jdbc.driver.OracleDriver;
            obj.drv=drv;
            clear drv;
            
            %make the connections
            fullurl=strcat('"jdbc:oracle:thin:@',obj.url,':', num2str(obj.port),'/',obj.db);
            conn = obj.drv.connect(fullurl, obj.props);
            obj.conn = conn;
        end
    end
    
end

