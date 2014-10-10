function out = PAYOUT(obj, Type, S, X, X1, T1, T2, V, R, Q)
% termPayout - termPayout value Option Price formula
%  Compute the intrinsic value of ablack futures option based on the parameters specified 
%  

%TODO : 

    if nargin < 7
        error('instruments.optionOnOption.PAYOUT: %s','Not enough parameters to calculate Payout Value');
    end;
    n = size(Type, 1);
    %Compound Option type
    indx = (T1>=0);
    type2 = ones(size(Type(indx),1), 1);
    type2(strcmpi(Type(indx), 'pp') | strcmpi(Type(indx), 'cp')) = -1;
    out = NaN(n,1);
    
    if any(~ismember(Type,{'cc' 'cp' 'pc' 'pp'}'))
        error('Invalid type flag');
    else
        if isempty(obj.UND.NPV)
            UND = obj.UND.optioncalc(obj.UND, 'NPV');
            UND = UND.NPV;
        else
            UND = obj.UND.NPV;
        end
         out(indx) = max(type2 .* UND(indx) - type2 .* X1(indx), 0 );
    end
    %make the instrinsic value the underlying if option on option T1
    %negative
    indx = (obj.T1<0);
    if any(indx)
        if isempty(obj.UND.NPV)
            UND = obj.UND.optioncalc(obj.UND, 'NPV');
            UND = UND.NPV;
        else
            UND = obj.UND.NPV(indx);
        end
        out(indx) = UND.INTRINSIC(indx);
    end

end

