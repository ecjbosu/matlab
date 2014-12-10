function addassemblies(PathName)

%ADDASSEMBLIES  Adds .NET assemblies

%   Persistent Variables

persistent Exclusions

if isempty(Exclusions)
    if strcmp(computer, 'PCWIN')
        Exclusions = {'win64' '.' '..'};
    else
        Exclusions = {'win32' '.' '..'};
    end
end

%   Parse Inputs

if nargin < 1 || isempty(PathName); PathName = gist.environment.netpath;  end

%   Extract Dlls

out       = dir(PathName);
FileNames = {out.name};

[~,FileNames,ext] = cellfun(@fileparts, FileNames, 'UniformOutput', false);
indx              = ismember(ext, '.dll');
FileNames         = FileNames(indx);
FullFileNames     = strcat(PathName, filesep, FileNames, ext(indx));

%   Disable Warnings

WarningStruct = warning;
warning('OFF', 'all')

%   Add .NET Assemblies

for i = 1:numel(FileNames)
    disp(['Adding .NET Assembly: ' FileNames{i}])
    NET.addAssembly(FullFileNames{i});
    setenv(FileNames{i}, FullFileNames{i});
end

%   Reset Warnings

warning(WarningStruct)

%   Extract SubFolders

indx = [out.isdir] & ~ismember({out.name}, Exclusions);
out  = out(indx);
out  = {out.name};

%   Recusive Call

for i = 1:numel(out)
    gist.environment.(mfilename)(fullfile(PathName, out{i}));
end