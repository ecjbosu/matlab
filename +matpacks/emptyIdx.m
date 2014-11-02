function out = emptyIdx( din )
%EMPTYIDX will determine the empty date strings and fill return indexes
%


    out = arrayfun(@(x) length(char(x)), din) == 0;


end

