function obj = setSQL( obj , ~ )
%setSQL initialize the sql property and fetch the data

    %set the sql string
    
    if nargin<2
        warning('connectors:connector:setSQL: no sql string');
    end
    
    %create the sql query
    datastmt=obj.conn.createStatement();
    data=datastmt.executeQuery(obj.SQL);
    
    %get the meta data.  This can be used to parse the input stream to the
    %data type as getNumber, getDate, getSting based on the columnType.
    %A fetch method is needed to return the correct data type and put them
    %in a matlab dataset.
    
    %%%%%%%%%start fetch
    meta=data.getMetaData();
    
    i = 1;
    obj.data=cell(1,meta.getColumnCount);
    
    while data.next()
        for j=1:1:meta.getColumnCount
            t1=data.getString(j);
            if isempty(t1)
                obj.data(i,j)=num2cell(NaN);
            else
                obj.data(i,j) = data.getString(j);
            end
        end
        i = i+1;
    end
    
    %%%%%%%%%%end of fetch
    
    %clean up
    data.close;
    datastmt.close;
    clear data datastmt meta;
    
end

