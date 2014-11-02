function [ out ] = cell2delimVar( title, delimiter,  data )
%cell2delimVar convert a cell array of strings to a single delimited
%variable
%   cell2delimVar will accept a cell array of string and convert to single
%   variable row vector of strings delimited with the input delimiter

% Example
%       cell2delimVar('DATECOLUMN', ',', {'Guy', 'was', 'here'});
%       results: DATECOLUMN,Guy,was,here

%TODO:  

    if nargin < 3 
        error('cell2delimVar requires 3 inputs');
    end
    
    if ~iscellstr(data) 
        if ~iscell(data)
            error('cell2delimVar data to be a cell array of strings or numbers');
        end
    end
    
    if ~ischar(delimiter)
        error('cell2delimVar delimiter to be a string');
    end
    
    if ~ischar(title) then
        error('cell2delimVar title to be a string');
    end
    
    out = [];
    
    if size(data, 1) > 1 && isempty(title)
    
        strcells = arrayfun(@iscellstr,data(1,:));
        
        for i = 1:1:size(strcells,2)
            if strcells(i) 
                
                out = [out char(strcat( '''', data(:, i), '''', delimiter)) ];
                
            else
                
                format = '%f,';
                
                if i == size(strcells,2); format = '%f'; end;
                
                out = [out  char(num2str(cell2mat(data(:,i)), format))];
                
            end
            if i+1 == size(strcells,2)
                
                delimiter = '';
                
            end
        end
        
    else
        if ~isempty(title)
            out = [[title delimiter]; strcat( data(1:(size(data)-1)), delimiter); data(end)];
        else
            out = [strcat( data(1:(size(data, 2)-1)), delimiter) data(end)];
            out = [out{:}];
        end
        
        
    end
    
    if ischar(out)
    
        out = out;
        
    else
        
        out = strcat(out{:});
        
    end


end

