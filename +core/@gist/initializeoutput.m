function    out = initializeoutput(obj, CopyFlag)

%   INITIALIZEOUTPUT
%
%   out = initializeoutput(obj, CopyFlag)
%
%       CopyFlag == true:   Returns a copy of obj
%       CopyFlag == false   Returns a reference to obj  (Default)

%   Parse Inputs

if nargin < 2 || isempty(CopyFlag); CopyFlag = false;   end

%   Convert to Logical (if possible)

CopyFlag = logical(CopyFlag);

%   Error Checking

if ~isscalar(CopyFlag)
    error('Invalid Input: SortFlag must be scalar logical')
end

%   Main

if CopyFlag
   out = obj.copy; 
else
   out = obj; 
end
