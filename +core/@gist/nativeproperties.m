function out = nativeproperties(obj, DynamicPropertyFlag, IndependentPropertyFlag)

%NATIVEPROPERTIES   Returns the native property names of obj
%
%   out = nativeproperties(obj, DynamicPropertyFlag)
%
%       Returns the native properties of obj
%
%       If DynamicPropertyFlag = true (Default)
%
%           native properties = Class Properties + Dynamic Properties -
%                               SuperClass Properties
%
%       If DynamicPropertyFlag = false
%
%           native properties = Class Properties - SuperClass Properties
%
%   out = nativeproperties(obj, DynamicPropertyFlag, IndependentPropertyFlag)
%
%       IndependentPropertyFlag = true (Default) - Only independent properties are returned.
%                               = false          - Only dependent   properties are returned
%                               = NaN            - Disabled

%   Parse Inputs

if nargin < 2 || isempty(DynamicPropertyFlag);      DynamicPropertyFlag     = true; end
if nargin < 3 || isempty(IndependentPropertyFlag);  IndependentPropertyFlag = true; end

%   Error Checking

if ~isscalar(obj);  error('Scalar object required');    end

if ~isscalar(DynamicPropertyFlag) && islogical(DynamicPropertyFlag)
    error('Invalid Input:  DynamicPropertyFlag must be a scalar logical')
end

if ~isscalar(IndependentPropertyFlag) && ...
        (islogical(IndependentPropertyFlag) || (isnumeric(IndependentPropertyFlag) && isnan(IndependentPropertyFlag)))
    error('Invalid Input:  IndependentPropertyFlag must be a scalar logical or NaN')
end


%   Extract ClassName or FieldNames

if DynamicPropertyFlag
    FieldNames = properties(obj);
else
    FieldNames = properties(class(obj));
end

%   Determine SuperClass Properties

SuperClassProps = obj.superclassproperties;

%   Remove SuperClass Properties

out = setdiff(FieldNames, SuperClassProps);
out = FieldNames(ismember(FieldNames, out));

%   Process IndependentPropertyFlag

if ~isnan(IndependentPropertyFlag)
    
    if IndependentPropertyFlag
        out = intersect(out, independentproperties(obj));
    else
        out = intersect(out, dependentproperties(obj));
    end
    
end
    
    



