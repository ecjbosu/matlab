function out = isequal(varargin)

%ISEQUAL    Returns a scalar logical comparing the datamatrix objects
%
%   out = isequal(obj1, obj2, obj3, ...)
%
%       Returns a scalar true if the the following are equal:
%
%           Object class
%           Object size
%           Native properties
%           Dynamic properties
%           Superclass properties (Except Timestamp)
%
%       Note:   Special attention is made to verify that the NaNs also agree.
%
%   %   out = isequal(obj1, obj2, obj3, ..., tol)
%
%       Specifies the tolerance tol for comparing numerical values.

%   Initialize Output

out = true;

%   Return if scalar

NumInputs = numel(varargin);

if NumInputs == 1
    return;
end

%   Parse Inputs

if isnumeric(varargin{end})
    tol           = varargin{end};
    varargin(end) = {};
else
    tol = 1e-6;
end

%   Extract First Object

obj = varargin{1};

%   Class Test

ClassTest = all(cellfun('isclass', varargin(2:end), class(obj)));

if ~ClassTest
    out = false;
    return
end

%   Size Tests

SizeTest = cellfun(@size, varargin, 'UniformOutput', false);

if ~isequal(SizeTest{:})
    out = false;
    return
end

%   Extract Properties

NumObj            = numel(obj);
AllProperties     = cell(NumObj,1);
DynamicProperties = cell(NumObj,1);

for j = 1:NumObj
    AllProperties{j}     = setdiff(properties(obj(j)), 'Timestamp');
    DynamicProperties{j} = dynamicproperties(obj(j));
end

%   Dynamic Property Test

i = 2;

while out && i <= NumInputs
    
    j = 1;
    
    while out && j <= NumObj
        out = all(strcmp(DynamicProperties{j}, dynamicproperties(varargin{i}(j))));
        j   = j+1;
    end
    
    i = i+1;

end

%   Isequal Tests

i = 2;

while out && i <= NumInputs
    
    tmp = varargin{i};
    j   = 1;
    
    while out && j <= NumObj

        k = 1;
        
        while out && k <= numel(AllProperties{j})
            out = Local_isequal(obj(j).(AllProperties{j}{k}),  tmp(j).(AllProperties{j}{k}), tol);
            k   = k+1;
        end
        
        j = j+1;
    
    end
    
    i = i+1;

end

%%  Local_isequal

function out = Local_isequal(obj1, obj2, tol)

if  isempty(obj1)
    
    out = isempty(obj2);
    
elseif isnumeric(obj1)

    nanindx = isnan(obj1(:));
    out     = all(nanindx == isnan(obj2(:)));
    out     = out && all(abs(obj1(~nanindx) - obj2(~nanindx)) < tol);

elseif isstruct(obj1)
    
    FieldNames = fieldnames(obj1);
    out        = all(strcmp(FieldNames, fieldnames(obj2)));
    
    i = 1;
    
    while out && i <= numel(FieldNames)
        out = Local_isequal(obj1.(FieldNames{i}),obj2.(FieldNames{i}));
        i   = i+1;
    end

elseif isa(obj1, 'gist:.gist')
    out = gist:.gist.isequal(obj1,obj2);
else
    out = all(isequal(obj1,obj2));
end