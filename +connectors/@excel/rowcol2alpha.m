function out = rowcol2alpha(row, col)

%ROWCOL2ALPHA  Converts a row, column cell reference to alphanumeric 


%   Persistent Variables

persistent CharNumA CharNumSpace

if isempty(CharNumA)
    CharNumA     = 65;
end

if isempty(CharNumSpace)
    CharNumSpace = 32;
end

%  Parse inputs

if nargin < 1 || isempty(row);   row = 1;  end
if nargin < 2 || isempty(col);   col = 1;  end


%  Scalar expansion

[row, col] = core.scalarexpand(row, col);

%  Error tests

edims = connectors.excel.validExceldims;

if any(row < 1) || any(row > edims(1));    error('connector.excel.rowcol2alpha:  1 <= row <= %d required', edims(1));  end
if any(col < 1) || any(col > edims(2));    error('connector.excel.rowcol2alpha:  1 <= col <= %d required', edims(2));    end

%  Ensure column vectors

rsize  = size(row);
row = row(:);
col = col(:);

%   Convert Row & Col to Alphanumeric reference

AlphaCol               = [floor((col-1)/26)+CharNumA-1 rem(col-1,26)+CharNumA];
AlphaCol(col <= 26, 1) = CharNumSpace;   

%   Convert to Cellstr

out = [char(AlphaCol) num2str(row)];
out = reshape(cellstr(out),rsize);
out = strrep(out,' ','');

%   Scalar Cell Expansion

if length(out) == 1;  out = out{1};  end

