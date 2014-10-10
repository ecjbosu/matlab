function fh = plot( obj, xaxisprop )
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
    if nargin < 2
         xaxisprop = 'S';
    end
    fh = [];
   if length(obj) >= 1 
   if (isempty(obj.NPV) && isempty(obj.Delta) && isempty(obj.Gamma) && isempty(obj.Rho) && ...
        isempty(obj.Theta) && isempty(obj.Vega) ...
        ) == false
    
        flds = fieldnames(obj);
        flds = flds(1:end-3); % remove core inherited fields
        idx = ismember(flds,cellstr(xaxisprop));
        typedef = obj.Typedef; 
        idx1 = [size(obj.NPV, 1)>0 size(obj.Intrinsic, 1)>0 ...
            size(obj.Delta, 1)>0 size(obj.Gamma, 1)>0 ...
            size(obj.Rho, 1)>0 size(obj.Phi, 1)>0 size(obj.Vega, 1)>0 ...
            size(obj.Theta, 1)>0 size(obj.Eta, 1)>0 size(obj.PayoutTerm, 1)>0 ]';
        subps = sum(idx1);
        idx1 = [zeros(size(flds,1)-size(idx1,1),1) ; idx1];%pad for the input fields
        xaxis = obj.(char(flds(idx)));
        if strcmpi(char(flds(idx)),'T')
            xaxis = xaxis * 365;
        end
        xaxislab = strcat(cellstr(num2str(xaxis(:), '%4.1f')));
        
        if subps>0
            fh = figure('Name',strcat('Digital Option',':',typedef));
            j = 1;
            for i = 1:1:length(idx1)
                if idx1(i) == true
                    subplot( (subps/2 + rem(subps,2)), 2,  j);
                    plot(xaxis, obj.(char(flds(i))));
                    xag = get(gca,'Xtick');
                    xag =  min(xag):round((max(xag)-min(xag))/10):max(xag);
                    set(gca,'Xtick', xag);
                    xla = xaxislab(1:round(length(xaxis)/length(xag)):length(xaxis));
                    if length(xla) < length(xag);
                        xla(end+1) = xaxislab(end);
                    end
                    set(gca,'XtickLabel', xla)                    %set(gca, 'XTickLabel', xaxislab);
                    title(flds(i));
                    xlabel(xaxisprop);
                    j = j + 1;
                end
            end
        else
            warning('instruments.Option: %s','Nothing to plot');
        end
    else
        warning('instruments.Option: %s','Nothing to plot');
   end
   else
        warning('Plot requires more than one option in the object');
   end
        
    fh = fh;
end

