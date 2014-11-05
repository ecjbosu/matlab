function obj = fetchDataString( obj , ~ )
%fetchDAtaSring fetch the data
% retrieve database query as cellstr only for export or cache
% no conversion done.

    %set the sql string
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
    tbl = {};
    
    while data.next()
        for j=1:1:meta.getColumnCount
            % see comment above on data types
            t1 = data.getString(j);
            if isempty(t1)
                tbl(i,j) = num2cell(NaN);
            else
                tbl(i,j) = cell(t1);
             end
        end
        i = i+1;
    end
    
    if ~isempty(tbl)
        obj.data = dataset({tbl, cols{:}});
    end
    
    %%%%%%%%%%end of fetch

    %clean up
    data.close;
    datastmt.close;
    clear data datastmt meta;
    
end

