function [out, indx] = pick(obj, MatchString)

%PICK   Returns the elements of obj whose tag matches the given input
%
%
%   out = pick(obj, MatchString)
%
%       Returns the elements of obj whose tag matched MatchString
%
%   [out, indx] = pick(obj, MatchString)
%

%   Extract Tag

Tag = {obj.Tag};

%   Parse Inputs

if nargin < 2 || isempty(MatchString);  
    MatchString = Tag;
end

%   Ensure Cellstr

MatchString = cellstr(MatchString);

%   Output

[~, indx] = ismember(MatchString, Tag);

if isempty(indx)
    out = repmatc(obj, size(MatchString));
    out.delete;
else
    out = obj(indx);
end