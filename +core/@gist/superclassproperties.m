function out = superclassproperties(obj)

%SUPERCLASSPROPERTIES   Returns the superclass property names of obj
%
%   out = obj.superclassproperties


%   Construct Metaclass   

mc = metaclass(obj);

%   Extract super class property names

out = {mc.SuperclassList.PropertyList.Name};