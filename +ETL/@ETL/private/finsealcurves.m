function out = finsealcurves( obj, startdt, enddt, tickers )
%finsealcurves download historical prices

%parse input and set default
if nargin < 1;    
    
    startdt = datestr(datenum(date())-1, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));  
    enddt   = datestr(datenum(date())-90, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));  
    
end

if isnumeric(startdt)
    startdt = datestr(startdt, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));
end
if isnumeric(enddt)
    enddt = datestr(enddt, char(gist.environment.nargsin('Programs', mfilename, obj.databaseSource)));
end

comm = 10000;

out = strcat( ...
      ' SELECT distinct TradeDate, ContractDate, CONTRACT, Settle from ', ...
      '       CommodityPrices.Futures f, CommodityPrices.Tickers t', ...
      '      WHERE t.Ticker in (', tickers, ')', ...
      '      AND t.Commodity = ', num2str(comm), ' ', ...
      '      AND f.CONTRACT in ( t.ticker, t.Electronic, t.OpenOutcry) ', ...
      '      AND TradeDate BETWEEN ''', startdt,''' AND ''', enddt,'''  ');
  
end

