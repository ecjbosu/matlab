function out = publicproperties(obj)

%PUBLICPROPERTIES   Returns the public property names of obj
%
%   out = publicproperties(obj)
%
%       Returns the public properties of obj

%   Error Checking

if ~isscalar(obj);  error('Scalar object required');    end

%   Extract Properties

out = properties(obj);

%   MetaData

m         = metaclass(obj);
SetAccess = {m.PropertyList.SetAccess};

%   Subset to Protected Properties

out = out(ismember(SetAccess, 'public'));



