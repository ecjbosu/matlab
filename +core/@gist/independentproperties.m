function out = independentproperties(obj, DynamicPropertyFlag)

%INDEPENDENTPROPERTIES   Returns the independent property names of obj
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

%   Parse Inputs

if nargin < 2 || isempty(DynamicPropertyFlag);  DynamicPropertyFlag = true; end

%   Error Checking

if ~isscalar(obj);  error('Scalar object required');    end

%   Extract ClassName or FieldNames

if DynamicPropertyFlag
    FieldNames = properties(obj);
else
    FieldNames = properties(class(obj));
end

%   Extract dependent property names

out = setdiff(FieldNames, dependentproperties(obj));
out = out(:);