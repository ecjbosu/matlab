function output = covf(x,varargin)

% function for comninging cov(x) and nancov(x) and additionally doing the
% spectral decomposition of the covariance matrix if it is not positive
% definite. 

% The Spectral Decomposition is achieved by specifying covf(x,'PSDFix')
% To function automatically checks whether there is NaN in the input data
% x. If NaN is found the function displays a warining and continues
% calculating the covariance matrix with the function nancov

% The inputs to this function can be covf(x,y,flag,'PSDFix')
% y is an optional vector
% flag determines whether to normalize by N (MLE estimate of covariance) or
% N-1 (standard case)

% Note that only x is the required to be input as a first argument. The
% order of the other 3 input arguments does not matter. The y,flag and
% 'PSDFix' arguments are optional and can be specified in any combination
% or order

% Check whether the number of input arguments is correct
if nargin==0 
  error('matpacks:stats:covf:NotEnoughInputs','Not enough input arguments.'); 
end
if nargin>5
  error('matpacks:stats:covf:TooManyInputs', 'Too many input arguments.'); 
end
if ndims(x)>2 
  error('matpacks:stats:covf:InputDim', 'Inputs must be 2-D.'); 
end
f =[];
psdflag = false;
fh = @cov;


%create a loop for calculating the covariance based on the number of inputs
for i= 1:numel(varargin)

% check whether a flag has been input    
if (isnumeric(varargin{i}) == 1 && isscalar(varargin{i}) && (varargin{i} == 0 || varargin{i} == 1)) 
       f = varargin{i};

% check whether a value for y has been input
elseif (isnumeric(varargin{i}) == 1) 
       y = varargin{i};
  if ndims(y)>2 
     error('matpacks:stats:covf:InputDim', 'Inputs must be 2-D.'); 
  end
  x = x(:);
  y = y(:);
  if length(x) ~= length(y), 
     
     error('matpacks:stats:covf:XYlengthMismatch', 'The number of elements in x and y must match.');
  end
  scalarxy = isscalar(x) && isscalar(y);
  x = [x y];
end

% check whether there are NaNs in the data
if sum(sum(isnan(x))) > 0
    warning('There is NaN in the data: The calculation will continue')
    fh = @nancov;
end

% check whether there is a 'PSDFix' input
if strcmp(varargin(i),'PSDFix') == 1
    psdflag=true;
else psdflag = false;
end
end

% calculate the covariance based on the above inputs
if ~isempty(f)
output = fh(x,1); % execute the nancov or cov based on handle and varargins
 else
     output = fh(x);
 end
if psdflag == true
   output = psdfix(output);
end
 
return
 
end
