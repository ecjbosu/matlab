function out = validColumnTypes(obj, in )
%validColumnTypes Valid column type for MySQL and Oracledatabase columns.  
%This comes from the metadata columntypename property for a JDBC query.
% Oracle types: varchar, number, date
% MySQL: the types are compress to the Oracel 3 types
%     number: TINYINT SMALLINT MEDIUMINT INT INTEGER BIGINT FLOAT DOUBLE 
%         DOUBLE PRECISION REAL DECIMAL NUMERIC YEAR 
%     date: DATE DATETIME TIMESTAMP TIME
%     varchar: CHAR VARCHAR TINYBLOB TINYTEXT BLOB TEXT MEDIUMBLOB 
%         MEDIUMTEXT LONGBLOB LONGTEXT ENUM SET
%   TODO: add MS SQL server types

% define oracle, mysql, mssqlsrv types arrays
oraclenums  = {'number'};
oracledates = {'date'};
oraclechars = {'varchar'};
mysqlnums   = {'tinyint' 'smallint' 'mediumint' 'int' 'integer' 'bigint' ...
                'float' 'double' 'double precision' 'real' 'decimal' ...
                'numeric' 'year'};
mysqldates  = {'date' 'datetime' 'timestamp' 'time'};            
mysqlchars  = {'char' 'varchar' 'tinyblob' 'tinytext' 'blob' 'text' ...
                'mediumblob' 'mediumtext' 'longblob' 'longtext' 'enum' ...
                'set'};
mssqlsrvnums    = {'number' 'int' 'decimal' 'numeric' 'bigint' 'bit' ...
                    'smallint' 'tinyint' 'float' 'real' };          
mssqlsrvdates   = {'date' 'datetime' 'timestamp' 'time'  'datetime2'};        
mssqlsrvchars   = {'varchar' 'nvarchar' 'char' 'text' 'nchar' 'ntext'};

%join all the type arrays
    nums  = [oraclenums, mysqlnums, mssqlsrvnums];
    chars = [oraclechars, mysqlchars, mssqlsrvchars];
    dates = [oracledates, mysqldates, mssqlsrvdates];

%strip out all numbers in the columntypename, mainly for oracle
    in = lower(regexprep(char( in ), '[0-9]', ''));
    in = lower(regexprep(char( in ), ' unsigned', ''));
    
    
    % set a default
    out = 'varchar';
    
    %test for the type
    if ismember(in, nums);          out = 'number';                     
    elseif ismember(in, dates);     out = 'date';
    elseif ismember(in, chars);     out = 'varchar';
    else
        %default to string with warning
        warning('connectors:connector:validColumnTypes: unknown column type defaulting to string');
    end
    

end

