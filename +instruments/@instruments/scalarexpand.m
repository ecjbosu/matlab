function varargout = scalarexpand(obj, varargin)
% scalarexpand 

%these are native properties that do not need to be expanded at this time
exnative = {'Exdef' 'Typedef'};

if isempty(varargin); 
    %scalar expand the obj
    props = obj.nativeproperties;
    props = props(~ismember(props, exnative));
    props = props(~ismember(props, obj.protectedproperties));
    [ props ] = core.scalarexpand(props);
    
else
    %scalar expand the varargin
    if ~isequal(size(Type),size(S),size(X),size(T),size(Exdef),size(R),size(Q),size(V));
        [ varargin ] = core.scalarexpand(varargin);
    end

end
