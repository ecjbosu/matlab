function xlobj = xlwrite(obj, FileName, NumberFormat, DeleteSheetsFlag, WritePropFlag, OpenFileFlag)

%   XLWRITE Writes datatable to an Excel spreadsheet
%
%   obj.xlwrite(FileName)
%
%       Writes obj to the given FileName (Default = tempname)
%
%   obj.xlwrite(FileName, NumberFormat)
%
%       Uses the input NumberFormat (Default = '* #,##0;[Red]* -#,##0')
%
%       NumberFormat may be a cellstr array equal to the size of obj 
%       This allows the number format to vary across the object dimension
%
%   obj.xlwrite(FileName, NumberFormat, DeleteSheetsFlag)
%   
%       DeleteSheetsFlag = false(Default) Keeps existing sheets
%       DeleteSheetsFlag = true           Deletes existing sheets
%
%   obj.xlwrite(..., WritePropFlag)
%   
%       WritePropFlag = true(Default)   Writes object properties to Excel
%       WritePropFlag = false           Does not write object properties
%
%   obj.xlwrite(..., OpenFileFlag)
%   
%       OpenFileFlag = true(Default)   Opens Excel if no output arguments
%       OpenFileFlag = false           Does not open Excel

%   Persistent Variable

persistent MaxRows MaxCols MaxSheetNameLength

if isempty(MaxRows)
    MaxRows = 64000;
end

if isempty(MaxCols)
    MaxCols = 256;
end

if isempty(MaxSheetNameLength)
    MaxSheetNameLength = 31;
end

%   Parse Inputs

if nargin < 2 || isempty(FileName);         FileName         = tempname;                  end
if nargin < 3 || isempty(NumberFormat);     NumberFormat     = {'* #,##0;[Red]* -#,##0'}; end
if nargin < 4 || isempty(DeleteSheetsFlag); DeleteSheetsFlag = [];                        end
if nargin < 5 || isempty(WritePropFlag);    WritePropFlag    = true;                      end
if nargin < 6 || isempty(OpenFileFlag);     OpenFileFlag     = true;                      end

%   Ensure Cellstr

NumberFormat = cellstr(NumberFormat);

%   Ensure .xls extension

FileName = [strrep(FileName, '.xls', '') '.xls'];

%   Default DeleteSheetsFlag

if isempty(DeleteSheetsFlag);   DeleteSheetsFlag = ~exist(FileName, 'file'); end

%   Error Checking

if ~ischar(FileName);           error('Invalid Input:  FileName must be a char');                end
if ~iscellstr(NumberFormat);    error('Invalid Input:  NumberFormat must be a char or cellstr'); end

if ~isscalar(DeleteSheetsFlag) && ~islogical(DeleteSheetsFlag)
    error('Invalid Input:  NewFlag must be a scalar logical');       
end

%   Scalar Expansion

NumberFormat = gist.gist.scalarexpand(NumberFormat, obj);

%   Max Row Error Checking

sz1 = obj.dims(1);

if any(sz1) > MaxRows;
    error(['Invalid Input:   Maximum number of rows in Excel is exceeded' char(10) ...
           'Max Rows = ' num2str(MaxRows)])
end

%   Max Column Error Checking

sz2 = obj.dims(2);

if any(sz1) > MaxCols;
    error(['Invalid Input:   Maximum number of columns in Excel is exceeded' char(10) ...
           'Max Columns = ' num2str(MaxCols)])
end

%   Error Checking: Tables only for now

if any(obj.naxes > 2);  error('Datamatrix objects with NumAxes > 2 are not supported by xlwrite');  end

%   

%   Open Excel Connection

try

    xlobj = dataconnect.excel(FileName);

    %   Delete Existing Sheets (if necessary)

    if DeleteSheetsFlag == true
        xlobj.deletesheets;
        xlobj.Application.Worksheets.Item(1).name = 'DeleteMe';
    end
    
    %   Get worksheets in current workbooks 
    
    NumOldSheets               = xlobj.Application.WorkSheets.Count;
    NumSheets                  = NumOldSheets + numel(obj);
    SheetNames                 = repmat({''}, NumSheets,1);
    SheetNames(1:NumOldSheets) = cellstr(xlobj.sheetnames);
    
   %   Loop Over Object
    
    for i = numel(obj):-1:1 %NumSheets:-1:NumSheets - numel(obj) + 1
        
        %   Determine SheetName Index
        
        sIndx    = NumOldSheets+i;
        sIndxNot = [1:sIndx-1 sIndx+1:numel(SheetNames)];
        
        %   Determine SheetName
        if ~isempty(obj(i).Label)
            SheetNames{sIndx} = obj(i).Label;
        elseif ~isempty(obj(i).Tag)
            SheetNames{sIndx} = obj(i).Tag;
        elseif ~isempty(obj(i).Ycategory)
            SheetNames{sIndx} = obj(i).Ycategory;
        else
            SheetNames{sIndx} = ['Sheet' num2str(i)];
        end

        %   Truncate SheetName
        
        SheetNames{sIndx}(MaxSheetNameLength+1:end) = [];
        
        %   Rename Duplicate SheetNames
        
        DuplicateCounter = 2;
        
        if ismember(SheetNames{sIndx}, SheetNames(sIndxNot))
            SheetNames{sIndx} = [SheetNames{sIndx} '(2)'];
        end
        
        while ismember(SheetNames{sIndx}, SheetNames(sIndxNot))
            DuplicateCounter  = DuplicateCounter+1;
            SheetNames{sIndx} = regexprep(SheetNames{sIndx}, '\(\d\)', ['(' num2str(DuplicateCounter) ')']);
        end

        %   Add WorkSheet
            
        ActiveSheet      = xlobj.Application.WorkSheets.Add;
        ActiveSheet.name = SheetNames{sIndx};
        
        %   Extract DynamicProperties & Core Properties
        
        Row = 1;
        
        if WritePropFlag
            
            PropNames = [obj(i).dynamicproperties; properties(gist.gist)];
        
            for j = 1:numel(PropNames);

                PropValue = obj(i).(PropNames{j});

                if ~isempty(PropValue) && isnumeric(PropValue) && datatables.calendar.isdate(PropValue);
                    PropValue = datestr(PropValue);
                end

                if ischar(PropValue) || isnumeric(PropValue)
                    ActiveSheet.Range(['A' num2str(Row)]).Value = PropNames{j};
                    ActiveSheet.Range(['B' num2str(Row)]).Value = PropValue;
                    Row = Row+1;
                end

            end

            Row = Row+1;

            ActiveSheet.Range('A1').ColumnWidth = 10;
            ActiveSheet.Range('B1').ColumnWidth = 15;

        end
        
        %   Determine xLabels:  Default empties to xValues

        xLabels  = obj(i).Xlabels;
        
        if  all(cellfun(@isempty, xLabels))
            xLabels = cellstr(num2str(obj(i).Xvalues(:)));
        end
        
        %   Determine yLabels:  Default empties to yValues

        yLabels = obj(i).Ylabels;
        
        if  all(cellfun(@isempty, yLabels))
            yLabels = cellstr(num2str(obj(i).Yvalues(:)))';
        end
        
        %   Determine Category
        
        Category = obj(i).Xcategory;
        
        if ~isempty(obj(i).Ycategory)
            Category = [Category '/' obj(i).Ycategory];  %#ok
        end

        
        %  Write yLabels

        %   Concatenate Category with yLabels
        
        yLabels = cat(2, Category, yLabels);
        
        %   Set StartCol
        
        if ~isempty(Category);  StartCol = 'A';
        else                    StartCol = 'B';
        end
        
        %   Determine CellRef
        
        CellRef = dataconnect.excel.rowcol2alpha(Row, sz2(i)+1);
        CellRef = [StartCol num2str(Row) ':' CellRef];  %#ok
        
        %   Write & Format
        
        ActiveSheet.Range(CellRef).Value       = yLabels;
        ActiveSheet.Range(CellRef).Font.Bold   = true;

        %   Set Column Width
        
        if isa(obj(i), 'datatables.hourlytable');    MinColumnWidth = 20;
        else                                            MinColumnWidth = 11;
        end
        
        for j = 1:numel(yLabels)
            CellRef                                = dataconnect.excel.rowcol2alpha(1, j);
            ColumnWidth                            = max([MinColumnWidth, 1.2*numel(yLabels{j}), ...
                                                          ActiveSheet.Range(CellRef).ColumnWidth]);
            ActiveSheet.Range(CellRef).ColumnWidth = ColumnWidth;
        end
        
        %   Write xLabels
        
        Row                               = Row+1;
        CellRef                           = ['A' num2str(Row) ':A' num2str(sz1(i)+Row-1)];
        ActiveSheet.Range(CellRef).Value  = xLabels(:);

        %   Write Data

        CellRef                          = dataconnect.excel.rowcol2alpha(sz1(i)+Row-1, sz2(i)+1);
        CellRef                          = ['B' num2str(Row) ':' CellRef]; %#ok
        ActiveSheet.Range(CellRef).Value = num2cell(obj(i).Values);
        
        if ~isempty(NumberFormat{i})
            if ismember('CurrencyFlag', nativeproperties(obj(i))) && obj(i).CurrencyFlag
                
                NewNumberFormat = ['$' strrep(NumberFormat{i}, '$', '')];
            
                if any(obj(i).Values < 1000)
                    NewNumberFormat = regexprep(NewNumberFormat, {'\.0*;' '\.0*'}, {'.000;' '.000'});
                    NewNumberFormat = strrep(NewNumberFormat, '[Red]', '[Red]$');
                end
                
            else
                NewNumberFormat = NumberFormat{i};
            end
            
            ActiveSheet.Range(CellRef).NumberFormat = NewNumberFormat;
        
        end
        
    end
    
    %   Delete Unused Sheets
    
    SheetNames   = setdiff(SheetNames, 'DeleteMe');
    AllSheets    = cellstr(xlobj.sheetnames);
    UnusedIndx   = ~ismember(AllSheets, SheetNames);
    xlobj.deletesheets(UnusedIndx);
    
catch ME
    xlobj.xlclose;
    rethrow(ME)
end

%   Display Excel Workbook and Release Connection (if necessary)

if nargout == 0
    if OpenFileFlag
        xlobj.Application.visible = true;
        xlobj.Application.release;
    else
        xlobj.xlclose;
    end
end