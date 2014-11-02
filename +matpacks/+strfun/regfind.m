function out = regfind( str, pat )
%REGFIND determines if a regular expresion is true or not.  Only works for
%scalar strings

out = regexp(str, pat);
out = ~cellfun(@isempty, out);

end

