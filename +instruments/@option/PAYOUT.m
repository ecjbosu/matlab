function out = PAYOUT(obj, Type, S, X, T, V, R, Q)
% termPayout - termPayout value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 7
        error('gist:instruments.option.Payout: %s','Not enough parameters to calculate Payout Value');
    end;
    type = obj.setType(Type);
%     if iscell(Type) || ischar(Type)
%         %type = ones(size(Type,1),1);
%         type = ones(size(Type));
%         type(strcmpi(Type,'p'))  = -1;
%     elseif strcmpi(class(Type),'double')
%         type = Type;
%     else
%         error('gist:instruments:option:%s: %s', mfilename, 'Option type error');
%     end
    
    out = max(type .* S - type .* X, 0 );
    
end

