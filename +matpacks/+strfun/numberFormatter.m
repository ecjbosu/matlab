function out = numberFormatter(in, formats, axis)
%NUMBERFORMATTER Format a number to a specified format using Java
%only works for 2D data
%numberFomatter( data, {'currency.0' 'currency.2' 'percentage.2' 'comma.0' 'comma.4'
%'percentage')
if nargin < 3
    error('matpacks:strfun:numberFormatter: %s', 'Data and formats required for numberFormatter');
end

import java.text.*;
import java.number.*;
import java.lang.*;

% rotate if row formatting
if axis == 1
    in = rot90(in, -1);
end

%set formats to same size as data
if numel(formats) ~= size(in, axis)

    formats = repmat(formats, size(in, axis), 1);
    
end

out = cell(size(in));

for i = 1:numel(formats)
   
    if strfind(lower(formats{i}), 'currency')
        %currency
        forstr = finddecimals(formats{i});
        forstr = ['$#,###' forstr];
        cf = java.text.DecimalFormat(forstr);
        t1 = in(:,i);
        if iscell(t1)
            t1 = cell2mat(t1);
        end
        idx = isnan(t1);
        out(~idx, i) = arrayfun(@(x) sprintf('%s', cf.format(x).toCharArray'), t1(~idx), 'UniformOutput', false);
    elseif strfind(lower(formats{i}), 'percentage')
        %percentage
        forstr = finddecimals(formats{i});
        forstr = ['#0' forstr '%'];
        t1 = in(:,i);
        if iscell(t1)
            t1 = cell2mat(t1);
        end
        idx = isnan(t1);
        cf = java.text.DecimalFormat(forstr);
        out(~idx, i) = arrayfun(@(x) sprintf('%s', cf.format(x).toCharArray'), t1(~idx), 'UniformOutput', false);

    elseif strfind(lower(formats{i}), 'comma')
        %comma
        forstr = finddecimals(formats{i});
        forstr = ['#,###' forstr];
        t1 = in(:,i);
        if iscell(t1)
            t1 = cell2mat(t1);
        end
        idx = isnan(t1);
        cf = java.text.DecimalFormat(forstr);
        out(~idx, i) = arrayfun(@(x) sprintf('%s', cf.format(x).toCharArray'), t1(~idx), 'UniformOutput', false);
    elseif strfind(lower(formats{i}), 'string')
        out(:, i) = in(:, i);
        
    else % none
        %this breaks
        out(:, i) =  cellstr(num2str(cell2mat(in(:,i))));
        
    end
    
end

% rotate back if row formatting
if axis == 1
    out = rot90(out, -3);
end




    function out = finddecimals(in)
        %build decimal sring
        out = regexp(in, '\.', 'split');
        
        if isscalar(out) || str2num(out{2}) == 0 
            out  = '';
        else
            out = ['.0' repmat('#', str2num(out{2}) - 1)];
        end
    end
                    
                

end

%formats = {'currency.0' 'currency.2' 'percentage.2' 'comma.0' 'comma.4' 'percentage'}
