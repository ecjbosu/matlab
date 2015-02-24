
MarkDate = '2013-03-28';

link = links.dbmart('iceDB', 'settles', 'NG');

a = ['SELECT Hub, Avg FROM martin_energy_trading.settles where Trade_Date =''' MarkDate ''''];

out = link.readdb(a);

link =  links.dbmart('iceDb', 'ICEMAP').dataset;

idx = cellfun(@isempty, link.MET_HUB, 'UniformOutput', false);
idx = [idx{:}];

link = link(~idx, :);

idx = cellfun(@(x) ismember(x, link.ICE_HUB), out.Hub);

out = out(idx, :);

out = dataset2cell(out)';
out = [{'MarkDate'; datestr(MarkDate, 'mm/dd/yyyy')} out];

out = [  cell(1,size(out, 2)); out];

out = cell2dataset(out);

archivepath = links.dbmart('iceDB', 'System', 'curvedir').ObservationDefault;
archivename = links.dbmart('iceDB', 'System', 'curvefile').ObservationDefault;

export(out, 'XLSfile', fullfile(archivepath, [archivename '.xlsx']), 'WriteVarNames',false);
