function out = setExpirations( obj, indata, dates )
%SETEXPIRATIONS Set the epiraiton dates givce a set of date vectors and
%trade types
%   Move to Portfolio class or datamatrix class in the future
%ADD error checking

    %refactor to portfolio dbmart system configuration with mappings to
    %true tradetype not these short names
    
    tradetypes  = {'Fut' 'Fin'};
    exchange	= {'ice'};
    
    out = dates;
    
    ids = false(numel(dates), 1);
    
    for i = 1: numel(tradetypes)
        [~, idx] = regexpi(indata, tradetypes{i}, 'match');
        idx     = ~cellfun(@isempty, idx);
        out(idx) = datatables.calendar.expiry(out(idx),[] , 'ice').Values;
        ids = idx | ids;
    end
    
    out(~ids) = dates(~ids);
    
end

