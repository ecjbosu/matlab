function out = setType(obj, Type)
% setType - set the option type based on the character specification
%  

%TODO : 

    if iscell(Type) || ischar(Type)
        %type = ones(size(Type,1),1);
        out = ones(size(Type));
        out(strcmpi(Type,'p'))  = -1;
    elseif strcmpi(class(Type),'double')
        out = Type;
    else
        error('instruments:%s: %s', mfilename, 'Option type error');
    end
    
   
end

