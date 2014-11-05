function out = sheetnames(obj)

%SHEETNAMES Returns the sheetnames associated with obj

%   Extract WorkSheets Object

WorkSheets = obj.Application.Worksheets;

%   Initialize Output

NumSheets = WorkSheets.Count;
out       = cell(NumSheets,1);

%   Loop over Number of Sheets

for i = 1:NumSheets
    out{i} = WorkSheets.Item(i).Name;
end

%   Release Excel Connection

WorkSheets.release;

%   Scalar Cell Expansion

if isscalar(out);   out = out{1};   end
