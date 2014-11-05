function out = xlread(~, FileName, SheetNames)

%   XLREAD  Reads datamart spreadsheet
%
%   out = connector.excel(FileName)
%
%       Reads the worksheets of the Excel workbook given by FileName into a 
%       contracttable array
%
%   out = connector.excel(FileName, SheetNames)
%
%       Reads only the sheets specified by SheetNames

%   Parse Inputs

if nargin < 2 || isempty(FileName);   error('Missing required FileName input');  end
if nargin < 3 || isempty(SheetNames); SheetNames = '';                           end

%   Ensure Cellstr

SheetNames = cellstr(SheetNames);

%   Error Checking

if ~ischar(FileName);        error('Invalid Input:  FileName must be a char');              end
if ~iscellstr(SheetNames);   error('Invalid Input:  SheetName must be a char or cellstr');  end

%   Initialize Output

out = repmatc(datatables.contracttable, size(SheetNames));

try

    %   Open Excel Connection

    obj = connector.excel(FileName);

    %   Default SheetNames

    if isempty(SheetNames{1})
       SheetNames = cellstr(obj.sheetnames);
    end

    %   Read SheetNames

    for i = 1:numel(SheetNames)
        ActiveSheet   = obj.Application.WorkSheets.Item(SheetNames{i});
        RawData       = ActiveSheet.UsedRange.Value;
        ContractDates = datenum(RawData(1,2:end));
        MarkDates     = datenum(RawData(2:end,1));
        DataValues    = RawData(2:end,2:end);
        DataValues    = reshape([DataValues{:}], size(DataValues));
        out(i)        = datatables.contracttable(DataValues, MarkDates, ContractDates);
    end
    
catch ME
    obj.xlclose;
    rethrow(ME)
end

obj.xlclose;
    