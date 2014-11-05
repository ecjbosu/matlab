function out = MSSQL( obj, in )
%MSSQL set the MSSQL java jdbc driver

 
    if ismember(lower(in), {'drv' 'driver' })

        import com.microsoft.jdbc.*

        out = javaObjectEDT('com.microsoft.sqlserver.jdbc.SQLServerDriver');
            
    elseif ismember(lower(in), {'open' 'connect'});

        jdbcstr = 'jdbc:sqlserver://';

        fullurl = strcat(jdbcstr, obj.url, ':', num2str(obj.port), ';DatabaseName=', obj.db);
        
        try
            out = obj.drv.connect(fullurl, obj.props);
           % out.setCatalog(obj.db);
        catch EX

            throw(EX);
            
        end

    else
        
        error('connectors:connector:JDBC:MySQL: %s', 'Invalid option');
            
    end            
end

