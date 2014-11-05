function obj = xlopen(FileName, SheetName, UpdateLinks, ReadOnly)

%XLOPEN Open existing Excel file

%  Parse Inputs

if nargin < 1 || isempty(FileName);      FileName      = '';     end
if nargin < 2 || isempty(SheetName);     SheetName     = '';     end
if nargin < 3 || isempty(UpdateLinks);   UpdateLinks   = false;  end
if nargin < 4 || isempty(ReadOnly);      ReadOnly      = false;  end

%   Error Checking

if ~ischar(FileName);                                   error('Invalid Input:  FileName must be a char');               end
if ~ischar(SheetName);                                  error('Invalid Input:  SheetName must be a char');              end
if ~isscalar(UpdateLinks) || ~islogical(UpdateLinks);   error('Invalid Input:  UpdateLinks must be a scalar logical');  end
if ~isscalar(ReadOnly)    || ~islogical(ReadOnly);      error('Invalid Input:  ReadOnlyFlag must be a scalar logical'); end

%   Ensure .xls Extension

if ~isempty(FileName);
    [PathName, FileName] = fileparts(FileName);
    FileName             = fullfile(PathName, FileName, '.xls');
end

%   Open Activex Connection

obj.Application  =  actxserver('Excel.Application');
obj.Workbook     =  obj.Application.Workbooks;

%   Disable Display Alerts

set(obj.Application, 'DisplayAlerts', false);

%   Open WorkBook

if 	exist(FileName, 'file')
    try
        invoke(obj.Workbook, 'open', FileName, UpdateLinks, ReadOnlyFlag);
    catch ME
        delete(obj.Application)
        throw(ME)
    end
else
    invoke(obj.Workbook, 'Add');
    obj.WorkBook.SaveAs(FileName);
end

%   Select SheetName

if ~isempty(SheetName)
    warning('SheetName Input: Not Functional Yet')
end
