

levelslink = links.dbmart('riskDB', 'baseLevels').dataset
stratlink = links.dbmart('riskDB', 'Strategies').dataset
traderlink = links.dbmart('riskDB', 'Traders').dataset
inslink = links.dbmart('curvesDB', 'Instruments').dataset


a={datatables.datatable.dsTOdm(datatables.datatable,...
             'MarkDate', false, 'yyyy-mm-dd', ...
             'StartDate', false, 'yyyy-mm-dd', ...
             {idkey, 'TTLVolume'}, ...
             @sum, t2t)};
         
         
