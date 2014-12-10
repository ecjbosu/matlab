function out = protectedproperties(obj)

%PROTECTEDPROPERTIES   Returns the protected property names of obj
%
%   out = protectedproperties(obj)
%
%       Returns the protected properties of obj

%   Error Checking

if ~isscalar(obj);  error('Scalar object required');    end

%   Extract Properties

out = properties(obj);

%   MetaData

m         = metaclass(obj);
SetAccess = {m.PropertyList.SetAccess};

%   Subset to Protected Properties

out = out(ismember(SetAccess, 'protected'));



