function addprop(obj, propName, propValue)

%ADDPROP    Adds a dynamic property to the object

%   Parse Inputs

if nargin < 2 || isempty(propName);   error('Missing required Property Name input PropName'); end

%   Add Property (Check for Existence)

for i = 1:numel(obj)

    if ~ismember(propName, properties(obj(i)))
        addprop@dynamicprops(obj(i), propName);
    end

    if nargin == 3
        obj(i).(propName) = propValue;
    end
    
end