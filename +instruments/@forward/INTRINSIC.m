function out = INTRINSIC(obj, S, X, T, R, Q)
% intrinsic - intrinsic value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 6
        error('instruments.forward.Intrinsic: %s','Not enough parameters to calculate Intrinsic Value');
    end;
    
    out = (S - X) .* exp(-R .* T);
    
end

