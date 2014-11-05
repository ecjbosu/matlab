function xlclose(obj, SaveFlag)

%XLCLOSE    Excel Application close

%   Parse Inputs

if nargin < 2 || isempty(SaveFlag); SaveFlag = true;    end

%   Main

if ~strcmp(class(obj.Application), 'handle')
    
    if SaveFlag
        obj.xlsave;
    end
    
    obj.Application.Quit;
    obj.Application.delete;

end