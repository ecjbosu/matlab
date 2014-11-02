function varargout = scalarexpand(varargin)

%SCALAREXPAND   set to common dimensions


%   Initialize Output

varargout = varargin;

%   Determine Input Sizes

sz     = cellfun(@size, varargin, 'UniformOutput', false);

%   Return if empty

if ~all(cellfun(@all, sz)); return; end

%   Determine Number of Dimensions

nDim = cellfun(@length, sz);
maxDim = max(nDim);

for i=1:numel(sz)
   sz{i}(end+1:maxDim) = 1; 
end

sz      = cat(1, sz{:});
maxSz   = repmat(max(sz), nargin, 1);
ratioSz = maxSz ./ sz;

%   Error Checking

dimCheck = ismember(unique(ratioSz), [1 maxSz(1,:)]);

if ~all(dimCheck);    error('core.scalerexpand: Inconsistent Dimensions');   end

%   perform Expansion

if any(ratioSz(:) ~= 1)

    for i = 1:numel(varargin)

       varargout{i} = repmat(varargin{i}, ratioSz(i,:));
        
    end
    
end