function out = setContractMonth( obj, dates, settle )
%SETCONTRACTMONTH Set the contractmonth dates given a set of date vectors and

    
    %
    if nargin < 3
        error('gist.ETL.ETL.setSettled: %s', 'All parameters required');
    end
    
    %take care of cash to prompt aggregation
    idx = datevec(dates);
    % 
    t1  = datevec(settle);
    % 
    idx =  idx(:, 1) == t1(:, 1) & idx(:, 2) == t1(:, 2);
    out = datatables.calendar.edate(dates(idx), 1, 'beg');

    % disp('reset FlowDay to Contract Month since rolling BOM to prompt for now');
    out    = datatables.calendar.fomdate(out).Values;

    
end


