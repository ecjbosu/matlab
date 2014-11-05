function obj = update( obj, data, tablename, defaultschema, wheres )
%update the data in a database table

 import matpacks.*;

    if nargin < 4
        error('Object does not contain a valid sql string, sql statement required: connector.fetch');
    end
    
    if ~strcmp(class(data), 'dataset')
    
        error('Object must be a dataset');

    end

    %create the sql query
    
    datastmt = obj.conn.createStatement();
    
    for i = 1:1:size(data, 1)
        sqlstr = ' set ';
        
        for j = 1:size(data, 2)
            
            if ~ismember(data.Properties.VarNames(j), wheres)
                
                sqlstr = [sqlstr char(data.Properties.VarNames(j)) '=''' ...
                    num2str(cell2mat(strfun.ds2cellstr(data(i, j)))) ''''];
                
                if j < size(data, 2)
        
                    sqlstr = [sqlstr ',' ];
                    
                end
                
            end
            
        end
        
        sqlstr = [sqlstr ' where ' wheres '=''' char(strfun.ds2cellstr(data(i, wheres))) ''''];
        datastmt.addBatch({['update ' defaultschema '.' tablename sqlstr ]});
        
    end
    
    info = datastmt.executeBatch;

    
    %%%%%%%%%%end of insert
    
    %clean up
    datastmt.close;
    clear datastmt;
    
end

