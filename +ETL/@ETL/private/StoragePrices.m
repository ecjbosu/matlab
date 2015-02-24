function out = StoragePrices( obj, ~, startdt, basis)
%STORAGEPRICES download storage prices.  

%parse input and set default
if nargin < 1;    
    startdt = datestr(datenum(date())-1, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));  
end
if nargin < 2;
    basis = 'Henry Hub';
end

if isnumeric(startdt)
    startdt = datestr(startdt, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));
end


out = strcat( ...
      ' SELECT a.MarkDate, a.ContractMonth, a.InputName, a.FieldValue + b.FieldValue as Value FROM ', ...
      ' (SELECT * FROM storage_inputs where MarkDate = ''', startdt, ''' ', ...
      '  AND FieldName = ''Basis'' AND InputName IN (', basis, ') ', ') a, ', ... 
      ' (SELECT * FROM storage_inputs where MarkDate =  ''', startdt, ''' ', ...
      '  AND FieldName = ''Futures'' ) b ', ...
      '  WHERE a.ContractMonth= b.ContractMonth');