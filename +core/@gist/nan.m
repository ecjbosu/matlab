function out = nan(InputSize)

%NAN    Constructs a NaN matrix using persistent variables for performance

persistent StoredSize StoredMat

%   Initialize Persistent Variables

if isempty(StoredSize)
    StoredSize = [0 0];
    StoredMat  = [];
end

%   Ensure Row Vector

InputSize = InputSize(:)';

%   Construct Output

if ~isequal(StoredSize, InputSize)
    out         = NaN(InputSize);
    StoredSize  = InputSize;
    StoredMat   = out;
else
    out = StoredMat;
end

