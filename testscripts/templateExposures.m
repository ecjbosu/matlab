function out = templateExposures( obj )
%TEMPLATEEXPOSURES get the template exposure table metadata
%   
%TODO: Move to portfolio

%read the exposures

disp('Read the exposures using the ETL class for exposures');

%PathName, FileName, SheetName, MarkDate
out  = obj.xlread(gist.environment.nargsin('VaRApp', 'exposures'),[],'P & L template',[],[]);

if isa(out, 'MException') ||  isa(out, 'char')
    error(out.message)
end

end

