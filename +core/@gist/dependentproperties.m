function out = dependentproperties(obj)

%DEPENDENTPROPERTIES   Returns the dependent property names of obj
%
%   out = obj.dependentproperties

%   Construct Metaclass   

mc = metaclass(obj);

%   Extract dependent property names

indx = [mc.PropertyList.Dependent];
out  = {mc.PropertyList.Name};
out  = out(indx);
out  = out(:);