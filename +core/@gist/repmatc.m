function out = repmatc(obj, varargin)

%   REPMATC  Creates copies of objects using the default constructor
%
%       This is a static method that is useful when initializing output.
%       It uses the built-in matlab repmat followed by the copy method
%       inherited from matlab.mixin.Copyable.


out = repmat(obj, varargin{:});
out = out.copy;