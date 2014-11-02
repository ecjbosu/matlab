function out = psdfix(x, varargin)

% psdfix deals with matrices that are not positive definite. It uses
% spectral decomposition to obtain the eigenvalues of the matrix that is
% not positive definite. Then the original matrix is reconstructed only
% using the eigenvalues that are greater than 0. The resulting matrix is
% positive difinite.
% varargin: 'NAN' set all NaN's to zero

if nargin==0 
  error('matpacks:stats:psdfix:NotEnoughInputs','Not enough input arguments.'); 
end
if nargin>5
  error('matpacks:stats:psdfix:TooManyInputs', 'Too many input arguments.'); 
end
if ndims(x)>2 
  error('matpacks:stats:psdfix:InputDim', 'Inputs must be 2-D.'); 
end

% set NaN's to zero if requried
if ~isempty(varargin) && strcmpi(varargin{1}, 'NAN')
   x(isnan(x)) = 0;
end
        [A V] = eig(x);
        v = diag(V);
        v(v<0) = min(v(v>0));
        v = diag(v);
        out = A * v * A';