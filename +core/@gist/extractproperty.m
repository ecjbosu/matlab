function out = extractproperty(obj, PropertyName)

%EXTRACTPROPERTY    Extracts the value of the given PropertyName from the
%                   encapsulted objects of obj

%   Parse Inputs

if nargin < 2 || isempty(PropertyName); error('Missing required input: PropertyName');  end

%   Error Checking

if ~ischar(PropertyName)
    error('Invalid Input: PropertyName must be a char')
end

if ~isscalar(obj);  error('Scalar object required');    end

%   Extract Properties

IndepProperties = independentproperties(obj);

%   Initialize Output

out         = cell(size(IndepProperties));
KeepFlag    = false(size(out));

%   Loop over PropertyList

for i = 1:numel(IndepProperties)
    
    %   Extract Property
    
    if isa(obj.(IndepProperties{i}), 'gist.gist') && ismember(PropertyName, obj.(IndepProperties{i}).independentproperties)
        out{i}      = obj.(IndepProperties{i}).(PropertyName);
        KeepFlag(i) = true;
    end
    
end

%   Apply KeepFlag

out = out(KeepFlag);

%   Scalar Cell Expansion

if numel(out) == 1; out = out{1};   end