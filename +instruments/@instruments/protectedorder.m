function out = protectedorder( obj, in)
%PROTECTEDORDER set the order of properties for printing and ploting


out  = {'NPV' 'Intrinsic' 'PayoutTerm' 'Delta' 'Gamma' 'Vega' ...
    'Rho' 'Phi' 'Theta' 'Eta' };

out = out(ismember(out, in));

end

