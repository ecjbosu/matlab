function out = PAYOUT(obj, S, X, T, R, Q)
% termPayout - termPayout value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 6
        error('instruments.forward.Payout: %s','Not enough parameters to calculate Payout Value');
    end;
    
    out = S - X;
    
end

