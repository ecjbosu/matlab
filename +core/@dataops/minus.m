function  out = minus(obj1, obj2)

%MINUS  Class operation minus (-)
%
%   out = MINUS(obj1, obj2) is the same as out = obj1 - obj2

%%  Call Operate

out = operate(obj1, obj2, str2func(mfilename));

%%   Call uminus if empty Values Property

if isa(obj1, 'datatables.datatable')

    indx      = cellfun(@isempty, {obj1.Values});
    
    if any(indx)
        out(indx) = -out(indx);
    end
    
end
