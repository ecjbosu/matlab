function out = rollingSum( din, windowsize )
%ROLLINGSUM will determine the empty date strings and fill return indexes
%
if nargin < 1
    error('matpacks:rollingSum: %s', 'a data array is required');
end
if nargin < 2 || isempty(windowsize);   windowsize = 10;                end

    out = filter(ones(1,windowsize), 1, din);


end

