function out = lag(X, laglength, padvalue, direction, AxisIndx)
% LAG - lag the elements of the matrix
% Lag will shift the matrix by the laglength and pad the resulting matrix
% with the pad value.  Direction and axis are for setting the last element
% location in the matrix and for shifting across the x or y axis.  The
% result will return matrix, out the same dimesions as X.
%
% Parameters
%       X           row or column vector, or matrix
%       laglength   how many element to shift, 1 is the default
%       padvalue    value pad the shifted matrix: NaN or Inf normally with
%           NaN the default
%       direction   'end' or 'first', end is default
%       axisIndx        'row' or 'column, row is default
% 
% Examples
% X = rand(10,5)
% matpacks.stats.lag(X)
% matpacks.stats.lag(X,2)
% matpacks.stats.lag(X,1,'first')
% matpacks.stats.lag(X,1[],'column')
% matpacks.stats.lag(X,1,'first','column')
% 

if nargin<1
  error('matpacks:stats:lag:NotEnoughInputs','Not enough input arguments.'); 
end
if nargin<2 || isempty(laglength)   laglength = 1;           end        %#OK
if nargin<3 || isempty(padvalue)    padvalue  = NaN;         end        %#OK
if nargin<4 || isempty(direction)   direction = 'end';       end        %#OK
if nargin<5 || isempty(AxisIndx)    AxisIndx      = 'row';   end        %#OK

%   Error Checking

if ndims(X)>2
    error('matpacks:stats:lag:TooManyDimesion','Lag will on work in 2 dimensions.'); 
end

if ~isscalar(padvalue) || ~isnumeric(padvalue)
    error('matpacks:stats:lag:TooManyDimesion:Invalid Input', 'Invalid Input: padvalue.'); 
end

if ~isscalar(laglength) || ~isnumeric(laglength)
    error('matpacks:stats:lag:TooManyDimesion:Invalid Input','Invalid Input: laglength.'); 
end

if iscell(AxisIndx) || ischar(AxisIndx) && ~ismember(AxisIndx,{'first','end'})
else
    error('matpacks:stats:lag:TooManyDimesion:Invalid Input', ...
        'Invalid Input: AxisIndx must be a cellstr or char and have a value in (first, end).'); 
end

if iscell(direction) || ischar(direction) && ismember(direction, {'row','column'})
else
    error('matpacks:stats:lag:TooManyDimesion:Invalid Input', ...
        'Invalid Input: direction must be a cellstr or char and have a value in (row, column).'); 
end

%Perform matrix manipulation for direction and axis.  These operations will
    %be reverse on exit

    AxisIndx = char(AxisIndx); %ensure char not cell array
    %flip columns to rows if needed.
    if strcmpi(AxisIndx(1:3), 'col')
        X = rot90(X, -1);
    end
    %flip matrix if last element is the first element of the vector
    if strcmpi(direction, 'first')
        X = flipud(X);
    end

    %Shift the matrix

    %set the varargout with the correct pad values
    if isnan(padvalue)
        out             = NaN(size(X));
    elseif isinf(padvalue)
        out             = inf(size(X));
    else
        out             = repmat(padvalue, size(X));
    end
    %set the final result, padvalues are overwritten 
    out(1+laglength:end, :)   = X(1:end-laglength, :);

    %Perform matrix manipulation for direction and axis.  This is reversing the
    %operations performed above

    %flip matrix if last element is the first element of the vector
    if strcmpi(direction, 'first')
        out = flipud(out);
    end

    %flip columns to rows if needed.
    if strcmpi(AxisIndx(1:3), 'col')
        out = rot90(out);
    end

end