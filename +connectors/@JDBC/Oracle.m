function out = Oracle( obj, in )
%Oracle set the Oraclejava jdbc driver

    if ismember(lower(in), {'drv' 'driver' })
        
        import oracle.jdbc.driver.OracleDriver.*;

        out = oracle.jdbc.driver.OracleDriver; 
            
    elseif ismember(lower(in), {'open' 'connect'});

        jdbcstr = '"jdbc:oracle:thin:@';

        fullurl = strcat(jdbcstr, obj.url, ':', num2str(obj.port), '/', obj.db);

        out = obj.drv.connect(fullurl, obj.props);

    else
        
        error('connectors:connector:JDBC:Oracle: %s', 'Invalid option');
            
    end            


end

