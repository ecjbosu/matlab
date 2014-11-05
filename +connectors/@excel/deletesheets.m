function deletesheets(obj, indx)

%DELETESHEETS    Deletes given worksheets

%   Parse Inputs

if nargin < 2 || isempty(indx); indx = obj.Application.WorkSheets.Count:-1:1;   end

%   Ensure Numeric indx

if ischar(indx);    indx = cellstr(indx);   end
if iscellstr(indx);
    SheetNames  = cellstr(obj.sheetnames);
    indx        = ismember(SheetNames, indx);
end

if islogical(indx); indx = find(indx);  end

%   Ensure Descending Order

indx = sort(indx(:)', 2, 'descend'); %#ok

%   Add Sheet (if Deleting all Sheets)

DeleteAllFlag = numel(indx) == obj.Application.WorkSheets.Count;

if DeleteAllFlag
   obj.Application.Worksheets.Add;
   indx = indx+1; 
end

%   Delete Sheets:  Loop over indx

for i = indx
    tmp =  get(obj.Application.WorkSheets, 'Item', i);
    tmp.Delete
end

%   Ensure SheetName = 'Sheet1' (if DeleteAllFlag)

if DeleteAllFlag
    obj.Application.Worksheets.Item(1).name = 'Sheet1';
end