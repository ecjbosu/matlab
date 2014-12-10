function out = uppertriangle(in, sz, k)

%UPPERTRIANGLE Construct an Upper Triangle Matrix from a Vector

if nargin < 1 || isempty(in);   error('Missing required input: in');    end
if nargin < 2 || isempty(sz);   error('Missing required input: sz');    end
if nargin < 3 || isempty(k);    k = 0;                                  end

%   Ensure Column Vector

in = in(:);

%   Initialize Output

out   = zeros(sz);
sz    = size(out);

%   Determine Indices

[i,j] = find(triu(ones(sz),k));
indx  = sub2ind(sz,i,j);

%   Insert Input

out(indx) = in;



