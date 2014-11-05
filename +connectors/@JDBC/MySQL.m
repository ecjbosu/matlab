function out = MySQL( obj, in )
%MySQL set the MySQL java jdbc driver

 
    if ismember(lower(in), {'drv' 'driver' })

        import com.mysql.jdbc.*

        out = javaObjectEDT('com.mysql.jdbc.Driver');
            
    elseif ismember(lower(in), {'open' 'connect'});

        jdbcstr = 'jdbc:mysql://';

        fullurl = strcat(jdbcstr, obj.url, ':', num2str(obj.port), '/', obj.db);

        try
            out = obj.drv.connect(fullurl, obj.props);
        catch EX

	  throw(EX);
	  
        end

    else
        
        error('connectors:connector:JDBC:MySQL: %s', 'Invalid option');
            
    end            
end

