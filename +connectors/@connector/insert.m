function obj = insert( obj, data, tablename, defaultschema, useColumnNames )
%insert insert the data into a database table
%obj = insert( obj, data, tablename, defaultschema, cuseColumnNames )
%   obj:    connection object
%   data:   a dataset
%   tablename: table to insert data
%   defaultschema: schema to write in
%   useColumnNames: use column names in insert statement (default  false


import matpacks.*;
import matpacks.datatypes.*;
import matpacks.strfun.*;

    if nargin < 3 
        error('Object does not contain a valid dataset, table, or connector connector.fetch');
    end
    if nargin < 4 || isempty(useColumnNames)
        useColumnNames = false;
    end
    
    if iscell(data)
        tdata = data;
    end
    if isa(data, 'dataset')
    
        %convert dataset to cellarray using Matlab strfun ds2cellstr
        tdata = dataset2cell(data);

    end
    
    VarNames = datatypes.cell2delimVar('', ',', tdata(1,:));
    
    tdata = datatypes.cell2delimVar('', ',', tdata(2:end, :));

    % take of NaNs to NULLS
    idx  = arrayfun(@(x) strfind(x, 'NaN'), cellstr(tdata), 'UniformOutput', false);
    idx  = [idx{:}];
    idx1 = cellfun(@isempty, idx);
    idx  = cell2mat(idx);
    
    if any(idx1) && ~isempty(idx)
        tdata(~idx1, :) = char(arrayfun(@(x) strrep(x, ' NaN', 'NULL'), cellstr(tdata(~idx1,:))));
    end
    %create the sql query
    
    datastmt = obj.conn.createStatement();
    
    if strcmpi(obj.databaseSource, 'MSSQL')
        defaultschema = '';
    else
        defaultschema = strcat(defaultschema, '.');
    end
        
    for i = 1:1:size(data,1)
       
        if useColumnNames
            datastmt.addBatch({['insert into ' defaultschema tablename ' ' ...
                '('  VarNames  ') ', ...
                'VALUES ( ' tdata(i, :)  ')']});
        else
            datastmt.addBatch({['insert into ' defaultschema tablename ' ' ...
                'VALUES ( ' tdata(i, :)  ')']});
        end
        
    end
    
    info = datastmt.executeBatch;

    
    %%%%%%%%%%end of insert
    
    %clean up
    datastmt.close;
    clear datastmt;
    
end

