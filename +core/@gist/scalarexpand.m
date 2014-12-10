function varargout = scalarexpand(varargin)

%SCALAREXPAND   Expand Matrices by repmatting to common dimensions


%   Initialize Output

varargout = varargin;

%   Determine Input Matrix Sizes

sz     = cellfun(@size, varargin, 'UniformOutput', false);

%   Return if empty

if ~all(cellfun(@all, sz)); return; end

%   Determine Number of Dimensions

NumDim = cellfun(@length, sz);
MaxDim = max(NumDim);

for i=1:numel(sz)
   sz{i}(end+1:MaxDim) = 1; 
end

sz      = cat(1, sz{:});
MaxSz   = repmat(max(sz), nargin, 1);
RatioSz = MaxSz ./ sz;

%   Error Checking: Input Dimensions

DimensionCheck = ismember(unique(RatioSz), [1 MaxSz(1,:)]);

if ~all(DimensionCheck);    error('Inconsistent Dimensions');   end

%   Scalar Expansion

if any(RatioSz(:) ~= 1)

    for i = 1:numel(varargin)

       varargout{i} = repmat(varargin{i}, RatioSz(i,:));
        
    end
    
end