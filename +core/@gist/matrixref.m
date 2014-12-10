function OutMat = matrixref(OutMat, InMat, OutIndx, InIndx, DimensionIndx)

%MATRIXREF  General matrix reference method for inserting, copying, and
%           deleting dimensions
%
% OutMat = copyindx(OutMat, InMat, OutIndx, InIndx, DimensionIndx)
%
%   Performs matrix referencing operations using the given matrices and 
%   indices along the given dimension
%
% This will result in one of the following actions
%
%   Replace (Default) (OutMat and InMat are nonempty, OutIndx is empty or all colons) 
%
%   OutMat = InMat(:,InIndx,:,...) 
%
%       Default InIndx = ':'
%
%   Insert (OutMat and InMat are nonempty, InIndx is empty or all colons) 
%           
%       OutMat(:,:,OutIndx,:,:,:,...) = InMat 
%
%   Copy  (OutMat and InMat are nonempty)
%
%       OutMat(:,:,OutIndx,:,:,:,...) = InMat(:,InIndx,:,...)
%
%
%   Delete (OutMat is nonempty, InMat is empty)
%
%       OutMat(:,:,OutIndx,:,:,:,...) = []
%
%   Defaults:
%
%   OutMat required   
%   InMat           = OutMat
%   OutIndx         = Colons
%   InIndx          = Colons
%   DimensionIndx   = 1

persistent ColonIndx

%   Initialize Persistent Variables

if isempty(ColonIndx)
    
    NumColons = 20;
    ColonIndx = cell(1, NumColons);
    
    for i = 1:NumColons
        ColonIndx{i} = repmat({':'}, [1 i]);
    end
    
end

%   Parse Inputs

if nargin < 1 || isempty(OutMat);   error('Missing required Input:  OutMat');   end

if nargin < 2;                            InMat         = OutMat;   end
if nargin < 3 || isempty(OutIndx);        OutIndx       = ':';      end     
if nargin < 4;                            InIndx        = ':';      end
if nargin < 5 || isempty(DimensionIndx);  DimensionIndx = 1;        end        

%   Add Colons to InIndx

InIndxColon                = ColonIndx{ndims(InMat)};
InIndxColon{DimensionIndx} = InIndx;

%   Add Colons to OutIndx

OutIndxColon                = ColonIndx{ndims(OutMat)};
OutIndxColon{DimensionIndx} = OutIndx;

%   Perform Index Operation

if ischar(OutIndx) && isequal(OutIndx, ':')
    OutMat = InMat(InIndxColon{:});
else
    OutMat(OutIndxColon{:}) = InMat(InIndxColon{:});
end
