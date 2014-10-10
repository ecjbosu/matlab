function fh = plot( obj, xaxisprop, results, longshort )
%plot function for Option object
% Example:
% plot(option)
% TODO:
%   1 fix the x-axis labels
%   2 add parameters to change the x-axis focus from price to time to
%   expiration, or other option variables.  This is needed for all plot
%   methods of all option classes.

% set the xaxis 
    %xaxis = strcat(cellstr(num2str(obj.S(:),'%4.0f')));

% determine number of subplots if any
    if nargin < 2 || isempty(xaxisprop)
         xaxisprop = 'S';
    end
    if nargin < 3 || isempty(results)
        results = obj.protectedproperties;
    end
    if nargin < 4 || isempty(longshort)
        longshort = 1;
    end
    %ensure cell array
    results = cellstr(results);
    
    fh = [];
   
    figName = upper(class(obj));
    if ~isempty(obj.Label)
        figName = obj.Label;
    end
        
    
    if length(obj) >= 1 
        if any(cell2mat(arrayfun(@(x) ~isempty(obj.(char(x))), obj.protectedproperties, 'UniformOutput', false)))

            flds = fieldnames(obj);
            flds = obj.removegist(flds); % remove core inherited fields

            flds = results;
            idx1 = arrayfun(@(x) size(obj.(char(x)), 1)>0,flds, 'UniformOutput', false);
            idx1 = [idx1{:}];
            subps = sum(idx1);
            flds = obj.protectedorder(flds(idx1));
            
            xaxis = obj.(xaxisprop);
            if ndims(obj.(xaxisprop)) > 1
                xaxis = mean(xaxis, 2);
            end
            
            if strcmpi(xaxisprop, 'T')
                xaxis = xaxis * 365;
            end

            if any(idx1)
                fh = figure('Name', figName);
                j = 1;
                for i = 1:1:numel(flds)
                    
                    if subps > 1
                        subplot( (subps/2 + rem(subps,2)), 2,  j);
                    end
                    
                    plot(xaxis, obj.(char(flds(i))) * longshort, 'LineWidth', 3);
                    xag = get(gca,'Xtick');
                    
                    if numel(xag) > 10
                        cnt = round((max(xag)-min(xag))/10);
                        xaxislab = strcat(cellstr(num2str(xaxis(:), '%4.0f')));
                    else
                        xaxislab = strcat(cellstr(num2str(xaxis(:), '%4.2f')));
                        cnt = (max(xag)-min(xag)) / 10;                        
                    end
                    
                    xag =  min(xag):cnt:max(xag);
                    set(gca,'Xtick', xag);
                    if cnt < 1
                        xla =xag;
                    else
                        xla = xaxislab(1:cnt:length(xaxis));
                    end
                    
                    if length(xla) < length(xag);
                        xla(end+1) = xaxislab(end);
                    end
                    
                    set(gca,'XtickLabel', xla)                    %set(gca, 'XTickLabel', xaxislab);
                    set(gca, 'FontSize', 8.0);
                    
                    title(flds(i));
                    xlabel(xaxisprop);
                    j = j + 1;
                    
                    set(gca, 'XLimMode', 'manual');
                    set(gca, 'XTickMode', 'manual');
                    
                end
            else
                warning('instruments.Option: %s','Nothing to plot');
            end
        else
            warning('instruments.Option: %s','Nothing to plot');
        end
           
        fh = fh;
    else
        
        warning('Plot requires more than one option in the object');
        
    end
end

