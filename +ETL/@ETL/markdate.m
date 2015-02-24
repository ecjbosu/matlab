function out = markdate( obj, in )
%markDate read the markdate file and return the current EOD
%
if isa(in, 'cell')
    in = char(in);
end

out = dataset('File', in, 'Delimiter', ',', 'ReadVarNames', false);
out = datenum(cellstr(out(1,1)));

end

