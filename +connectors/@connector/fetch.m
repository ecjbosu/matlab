function obj = fetch( obj , sqlstr )
%FETCH initialize the sql property and fetch the data

    %handle sql empty, structure (SQL), or string
    if nargin < 2 && (~isstruct(obj.SQL) && ~ischar(obj.SQL) && ~iscell(obj.SQL))
        
        error('Object does not contain a valid sql string, sql statement required: connector.fetch');
        
    end
    
    % set the sql string
    if isstruct(obj.SQL)
        
        sqlstr = obj.SQL(1).sqlStr;
        
    elseif ischar(obj.SQL)
        
        sqlstr = obj.SQL;
        
    elseif iscell(obj.SQL)
        
        sqlstr = char(obj.SQL);
        
    else 
        
        error('Object does not contain a valid sql string, sql statement required: connector.fetch');
            
    end
    
    %create the sql query

    datastmt = obj.conn.createStatement();
    data = datastmt.executeQuery(sqlstr);

    %get the meta data.  This can be used to parse the input stream to the
    %data type as getNumber, getDate, getSting based on the columnType.
    %A fetch method is needed to return the correct data type and put them
    %in a matlab dataset.
    
    %%%%%%%%%start fetch
    
    meta = data.getMetaData();
    cols =  cell(1,meta.getColumnCount);
    
    for i = 1:1:meta.getColumnCount
        
         if meta.getColumnLabel(i).isEmpty
            cols(i) = meta.getColumnName(i).toString;
         else
            cols(i) = meta.getColumnLabel(i).toString;
         end
         
    end
    
    cols = cell(cols)'; 
    i = 1;
    t1 = cell(1, meta.getColumnCount);
    
    obj.data = dataset(t1{:},'VarNames', cols);
    
    while data.next()
        
        t.data = dataset({cell(1,meta.getColumnCount),cols{:}});
        
        for j = 1:1:meta.getColumnCount
            
            % see comment above on data types just in case a dbnull is returned.
            t1 = data.getString(j);
            
            if isempty(t1)
                
                t.data(1,j) = dataset({NaN});
                
            else
                
                type = obj.validColumnTypes(lower(regexprep(char( ...
                        meta.getColumnTypeName(j).toString), ...
                        '[0-9]','')));
                
                switch type;
                    case {'varchar'}
                        t.data(1,j) = dataset(cell(data.getString(j)));
                    case {'number'}
                        t.data(1,j) = ...
                            dataset({sscanf( ...
                            char(data.getString(j)),'%f')}); 
                    case {'date'}
                        t.data(1,j) = ...
                            dataset({datenum( ...
                                char(data.getString(j)))}); 
                    otherwise
                        t.data(1,j) = dataset(data.getString(j));
                 end
                 
            end
            
        end
        
        obj.data(i,:) = t.data(1,:);
        i = i+1;
        
    end
    
    %%%%%%%%%%end of fetch
    
    %clean up
    data.close;
    datastmt.close;
    clear data datastmt meta;
    
end

