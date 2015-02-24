

dts = datatables.calendar.monthly('4/1/2013', '3/31/2014')
dts.Values(end+1)=datenum('3/29/2013')

typs = [repmat( cellstr('fut'), 12 ,1); cellstr('Swing')]

o = ETL.ETL;
exp = o.setExpirations(typs, dts.Values)

datestr(exp)


