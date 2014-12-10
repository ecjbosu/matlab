function out = dynamicproperties(obj)

%DYNAMICPROPERTIES   Returns the dynamic property names of obj
%
%   out = dynamicproperties(obj)
%
%       Returns the dynamic properties of obj

%   Extract PropertyNames

PropertyNames    = nativeproperties(obj, true);
NativeProperties = nativeproperties(obj, false);  

%   Remove SuperClass Properties

out = setdiff(PropertyNames, NativeProperties);
out = PropertyNames(ismember(PropertyNames, out));
