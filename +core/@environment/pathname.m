function out = pathname(varargin)

%PATHNAME   Returns the pathname associated with the given input
%
%   out = gist.environment.pathname(PropertyName, PropertySetting)
%

%   Import gist Environment

import gist.environment

%   Error Checking: Property/Value pairs

if mod(numel(varargin),2);  error('Incorrect number of arguments: Property/Value pairs required');   end

%   Error Checking: ValidNames

ValidNames = gist.environment.validnames;
InputNames = varargin(1:2:end);

if ~all(ismember(InputNames, ValidNames));
    disp('Valid names are:')
    disp(ValidNames)
    error('Invalid Input: Valid environment name required.  See gist.environment.validnames')
end

%   Error Checking: ValidSettings

ValidSettings = gist.environment.validsettings;
InputSettings = lower(varargin(2:2:end));

if ~all(ismember(InputSettings, ValidSettings));
    disp('Valid settings are:')
    disp(ValidSettings)
    error('Invalid Input: Valid environment settings required.  See gist.environment.validsettings')
end

%   Extract Environment Names

DatabaseIndx       = ~cellfun(@isempty,  regexp(InputNames, 'Database'));
CacheIndx          = ~cellfun(@isempty,  regexp(InputNames, 'Cache'));
ApplicationIndx    = ~cellfun(@isempty,  regexp(InputNames, 'Applications'));
XmlIndx            = ~cellfun(@isempty,  regexp(InputNames, 'Xml'));

%   Determine RootName

LocalIndx              = ismember(InputSettings, 'local');
BetaIndx               = ismember(InputSettings, 'beta');
DevIndx                = ismember(InputSettings, 'development');
StagingIndx            = ismember(InputSettings, 'staging');
ProdIndx               = ismember(InputSettings, 'production');

RootName               = cell(size(InputNames));
RootName(LocalIndx)    = {environment.localpath};
RootName(DevIndx)      = {environment.developmentpath};
RootName(BetaIndx)     = {environment.betapath};
RootName(StagingIndx)  = {environment.stagingpath};
RootName(ProdIndx)     = {environment.productionpath};

%   Determine FolderName1

FolderName1                   = repmat({'dbMart'}, size(InputNames));
FolderName1(ApplicationIndx)  = repmat({'Applications'}, size(find(ApplicationIndx)));

%   Determine FolderName2

FolderName2                  = cell(size(InputNames));
FolderName2(DatabaseIndx)    = {'bins'};
FolderName2(CacheIndx)       = {'mat'};
FolderName2(XmlIndx)         = {'xml'};
FolderName2(ApplicationIndx) = {''}; 

%   Output PathNames

out = cell(size(InputNames));

for i = 1:numel(InputNames)
    out{i} = fullfile(RootName{i}, FolderName1{i}, FolderName2{i});
end






