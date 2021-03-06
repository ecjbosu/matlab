function out = setSettled( obj, tradetypeList, settleDates, MarkDate, dealsys )
%SETSETTLED Set the settled dates given a set of date vectors and
%trade types for filtering settled contracts
%   Move to Portfolio class or datamatrix class in the future
%ADD error checking
%
%ONLY SWINGS filter greater than nexttrading day.  These are  next next
%trading day
    %refactor to portfolio dbmart system configuration with mappings to
    %true tradetype not these short names
    
    %
    if nargin < 5
        error('gist.ETL.ETL.setSettled: %s', 'All parameters required');
    end
    
    tradetypeflag = false;
    
    if ~isempty(tradetypeList);    tradetypeflag = true;                   end
    if ~isnumeric(MarkDate);       MarkDate = datenum(MarkDate);           end
    
%really bastardized way to handle this.  Move to metadata and create a
%method to load this mapping.  Note Jimbo worked fine 
    if strcmpi(dealsys, 'DEAL1')  
         
       tradetypes = [ {'Fixed Price Swing Swaps'},     2; ...
           {'NYMEX Futures'},               1; ...
           {'Financial Basis'},             1; ...
           {'Storage Model'},               1; ...
           {'Fixed Price'},                 1; ...
           {'Financial Index Swing Swaps'}, 2; ...
           {'Physical Basis'},              1; ...
           {'Physical Index'},              1; ...
           {'Forward Start Options'},       1; ...
           {'NYMEX Options'},               1; ...
           {'Simple Tport'},                1; ...
           {'Transport Model'},             1; ...
           {'Transportaion Model'},         1; ...
           {'Exercised NYMEX Option'},      1; ...
           {'Storage Injection'},           1; ...
           {'Storage Withdrawal'},          1; ...
           ];

    else
        tradetypes = [ {'Fixed Price Swing Swaps'},     1; ...
                       {'NYMEX Futures'},               1; ...
                       {'Financial Basis'},             1; ...
                       {'Storage Model'},               1; ...
                       {'Fixed Price'},                 1; ...
                       {'Financial Index Swing Swaps'}, 1; ...
                       {'Physical Basis'},              1; ...
                       {'Physical Index'},              1; ...
                       {'Forward Start Options'},       1; ...
                       {'NYMEX Options'},               1; ...
                       {'Simple Tport'},                1; ...
                       {'Transport Model'},             1; ...
                       {'Transportaion Model'},         1; ...
                       {'Exercised NYMEX Option'},      1; ...
                       {'Storage Injection'},           1; ...
                       {'Storage Withdrawal'},          1; ...
                       ];
                   
    end
    
    out = false(numel(settleDates), 1);
        
    if tradetypeflag
        
        for i = 1: size(tradetypes,1)

            %find all that match this tradetype
            [~, idx] = regexp(tradetypeList, tradetypes{i , 1}, 'match');
            idx     = ~cellfun(@isempty, idx);
            
            %only non index need this adjustment for MAZI
                idx1 = ones(numel(settleDates(idx)), 1);
            if strcmpi(dealsys, 'DEAL1')        
            else
                %do month check in leui of product code
                mdd = datevec(MarkDate);
                sdd = datevec(settleDates);
                
                idx1 = mdd(:,2) == sdd(:,2);
            end
% filter off PNL run date against expiration.  If fut settle today, no
% exposure tomorrow, swing are done for the next 2 PNL run date
             out(idx&idx1)     = settleDates(idx&idx1) >= ...
                  datatables.calendar.tradingdayoffset(datenum(MarkDate), 1 .* tradetypes{i , 2}).Values;
             out(idx&~idx1)     = settleDates(idx&~idx1) >= ...
                  datatables.calendar.tradingdayoffset(datenum(MarkDate), 1).Values;

        end
        
    else
        
        %set other settles like run date must be less than expirations or
        %only include unexpired trades
        out = settleDates < MarkDate;
%         out = out(idx);
        
    end
    
end


