classdef excel < connector
    
    %EXCEL  create an Excel comm commection
    
    %obj = connector.excel(FileName, SheetNames{1}, false, true);

    properties
    
        Application = [];
        WorkBooks   = [];   
        
    end
    
    methods(Static)
        
        out = rowcol2alpha(row, col)
        out = validExceldims;
        
    end
    
    methods
 
        function obj = excel(varargin)

            if nargin == 0 
                return 
            elseif nargin == 1 && isa(varargin{1}, class(obj))
                obj = varargin{1}.copy;
            else
                try
                    obj.xlopen(varargin{:});
                catch ME
                    
                    if ~isempty(obj.Application)
                        obj.xlclose;
                    end
                    
                    throw(ME)
                
                end
           end

        end
        
        function xlopen(obj, FileName, SheetName, UpdateLinks, ReadOnly)

            %XLOPEN Open existing Excel file

            %  Parse Inputs

            if nargin < 2 || isempty(FileName);      FileName      = '';     end
            if nargin < 3 || isempty(SheetName);     SheetName     = '';     end
            if nargin < 4 || isempty(UpdateLinks);   UpdateLinks   = false;  end
            if nargin < 5 || isempty(ReadOnly);      ReadOnly      = false;  end

            %   Error Checking

            if ~ischar(FileName);                                   error('Invalid Input:  FileName must be a char');               end
            if ~ischar(SheetName);                                  error('Invalid Input:  SheetName must be a char');              end
            if ~isscalar(UpdateLinks) || ~islogical(UpdateLinks);   error('Invalid Input:  UpdateLinks must be a scalar logical');  end
            if ~isscalar(ReadOnly)    || ~islogical(ReadOnly);      error('Invalid Input:  ReadOnlyFlag must be a scalar logical'); end

            %   Ensure .xls Extension

            if ~isempty(FileName);
                [PathName, FileName] = fileparts(FileName);
                ext = core.environment.validExceltypes;
                FileName             = fullfile(PathName, [FileName '.' ext ]);
            end

            %   Open Activex Connection

            obj.Application  =  actxserver('Excel.Application');
            obj.WorkBooks    =  obj.Application.Workbooks;

            %   Disable Display Alerts

            set(obj.Application, 'DisplayAlerts', false);

            %   Open WorkBook

            if 	exist(FileName, 'file')
                invoke(obj.WorkBooks, 'open', FileName, UpdateLinks, ReadOnly);
            else
                obj.WorkBooks.Add;
                
                %   Determine the xl file format to use
                
                xlFormat = obj.xlFileFormat(FileName);
    
                %   Save the workbook in the file format
                
%                 obj.Application.ActiveWorkbook.SaveAs(FileName, xlFormat)
            end

            %   Select SheetName

            if ~isempty(SheetName)
                warning('SheetName Input: Not Functional Yet') %#ok
            end
            
        end
    
    end
end
