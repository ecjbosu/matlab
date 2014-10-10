function varargout = scalarexpand(obj, varargin)
% scalarexpand 
% classes

%these are native properties that do not need to be expanded at this time
exnative = {'Exdef' 'Typedef'};

if isempty(varargin); 
    %scalar expand the obj
    props = obj.nativeproperties;
    props = props(~ismember(props, exnative));
    props = props(~ismember(props, obj.protectedproperties));
    [ props ] = gist.gist.scalarexpand(props);
    
else
    %scalar expand the varargin
    if ~isequal(size(Type),size(S),size(X),size(T),size(Exdef),size(R),size(Q),size(V));
        [ varargin ] = gist.gist.scalarexpand(varargin);
    end

end
