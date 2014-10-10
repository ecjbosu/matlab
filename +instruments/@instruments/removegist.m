function out = removegist( obj, in )
%REMOVEGIST remove the gist.gist properties from a property cell array


idx = ~ismember( in, publicproperties(gist.gist));
out = in(idx);

end

