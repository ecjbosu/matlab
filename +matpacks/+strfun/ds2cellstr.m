function b = ds2cellstr(a,vars)
%ds2cellstr Create cell array of strings from dataset array.
%   B = CELLSTR(A) returns the contents of the dataset A, converted to a
%   cell array of strings.  The variables in the dataset must support the
%   conversion and must have compatible sizes.
%
%   B = CELLSTR(A,VARS) returns the contents of the dataset variables specified
%   by VARS.  VARS is a positive integer, a vector of positive integers,
%   a variable name, a cell array containing one or more variable names, or a
%   logical vector.
%
%   See also DATASET, DATASET/DOUBLE, DATASET/REPLACEDATA.

%   Copyright 2009 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2009/10/10 20:10:54 $

if nargin < 2 || isempty(vars)
    %vars = 1:size(a,2);   %replaced a.nvars with size since a.nvars is private in a dataset
    vars = a.Properties.VarNames;
else
    vars = getvarindices(a,vars,false);
end
if length(vars) == 0
    b = cell(size(a,1),0); %replaced a.nobs with size since it is private in a dataset
    return
end

b = cell(1,length(vars));
for j = 1:length(vars)
    try
        b{j} = cellstr(a(:,vars(j)));
    catch ME
        try
            b{j} = num2cell(double(a(:,vars(j))));
        catch ME
            throw(addCause(MException('stats:dataset:cellstr:ConversionError', ...
              'Error when converting ''%s'' to cell array of strings.', vars{j}),ME));
        end
    end
end
try
    b = [b{:}];
catch ME
    if strcmp(ME.identifier,'matpacks:catenate:dimensionMismatch')
        error('stats:dataset:cellstr:DimensionMismatch', ...
              'Dataset variable dimensions are incompatible.');
    else
        throw(addCause(MException('stats:dataset:cellstr:HorzCatError', ...
              'Error when concatenating dataset variables as cell arrays of strings.'),ME));
    end
end
