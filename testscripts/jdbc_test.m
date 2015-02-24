
%JDBC Test Script
%   Detailed explanation goes 'here


user = 'ecjbosu';
url = '76.30.78.124';
%url = '64.202.189.170';

port = 3306;
schema = '';
db = 'CommodityPrices';

passwd = 'professor';

    
    import dataconnect.*;
    
    s='select * from CommodityPrices.Tickers where Commodity=10000';
    
    o=JDBC(user, passwd, url, port, db);
    o.SQL=s;
    o=fetchFast(o);
    
    %% or Prefered
    import dataconnect.*;
    
    
    o=JDBC(user, passwd, url, port, db);
    o.SQL=s;
    o=fetch(o);
    o.close;
    
    
    %test nargins
    %empty sql error out

    o=JDBC(user, pwd, url, port, db);
    o.SQL=[];
    o=fetch(o);
    
    %empty sqlstr with sql string in object o
 
    a=tic;
   %o=fetch(o);
    o=fetchFast(o);
    b=toc(a);
    b
    
    o.close;

    
                  %Thanks to Matteo Broggi for this suggestion
%                   import java.util.*;
%                   import com.mysql.jdbc.*;
% 
%                 prop = java.util.Properties();
%                 prop.setProperty('user', user);
%                 prop.setProperty('password', passwd);
%                 driver = com.mysql.jdbc.Driver;
%                 furl = ['jdbc:mysql://' url '/' db];
%                 dbConn = driver.connect(furl, prop);
