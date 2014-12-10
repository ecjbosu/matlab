function out = strcat(inStr, delim) 

%STRCAT Concatenates cell strings with a the given delim
%
%   out = strcat(inStr, delim) 
%
%       Concatenates inStr with the given delim (Default = ', ')

%   Parse Inputs

if nargin < 2 || isempty(delim);    delim = {', '};    end

%   Error Checking

if ~iscellstr(inStr);    error('Invalid Input: inStr must be a cellstr'); end

%   Ensure Cellstr

delim = cellstr(delim);

%   Ensure Row Vector

inStr = inStr(:)';

%   Initialize Output

N              = numel(inStr);
out            = cell(2*N-1,1);

%   Concatenate


out(1:2:2*N-1) = inStr;
out(2:2:2*N-1) = delim;

%   Convert to Char

out = [out{:}];