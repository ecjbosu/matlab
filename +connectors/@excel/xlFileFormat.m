function out = xlFileFormat( obj, filename )
%XLFILEFORMAT Determine the file format from the extension.  
%   
%
% See xlswrite for details on this issue.

%   Determine the file extension

        [~, ~, ext] = fileparts(filename);

	%   Set the xl file format

            switch ext
                case '.xls' %xlExcel8 or xlWorkbookNormal
                   xlFormat = -4143;
                case '.xlsb' %xlExcel12
                   xlFormat = 50;
                case '.xlsx' %xlOpenXMLWorkbook
                   xlFormat = 51;
                case '.xlsm' %xlOpenXMLWorkbookMacroEnabled 
                   xlFormat = 52;
                otherwise
                   xlFormat = -4143;
            end
            
            out = xlFormat;

end

