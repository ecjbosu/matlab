
%VARPLOT POC

idx = strcmpi(varObj.Parms.Covar.Xlabels , 'NG')
sum(idx)
diag(varObj.Parms.Cover.Values(idx,idx))
diag(varObj.Parms.Covar.Values(idx,idx))
vol = diag(varObj.Parms.Covar.Values(idx,idx));
plot(vol)
plot(sqrt(vol))
plot(sqrt(vol*252))