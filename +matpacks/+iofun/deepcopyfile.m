function deepcopyfile(fromPath, toPath)

%deepcopyfile    Recursively copies the directory structure the given 
%pathname and its subfolders.  
%Example:
%matpacks.iofun.deepcopyfile('i:\ngg\ISTDCT\NAGP_Market_Risk\TST\Power\BulkInputs', 'i:\ngg\ISTDCT\NAGP_Market_Risk\TST\PowerOPT\BulkInputs')
%   Persistent Variables

persistent Exclusions

if isempty(Exclusions)
    if strcmp(computer, 'PCWIN')
        Exclusions = {'.' '..'};
    else
        Exclusions = {'.' '..'};
    end
end

%   Parse Inputs

if nargin < 1 || isempty(fromPath); error('Missing required input:  fromPath'); end
if nargin < 2 || isempty(fromPath); error('Missing required input:  toPath'); end

%   Error Checking

if ~ischar(fromPath);  error('Invalid Input:   fromPath must be a char');              end
if ~ischar(toPath);    error('Invalid Input:   toPath must be a char');              end

%   Return (if Package)

if ~isempty(regexp(fromPath, '+', 'once'))
    return
end

%   Determine Function
    disp(['Copying files: ' fromPath ' to ' toPath])
%     AddPathFcn = @matpacks.iofun.folderCheckCreate;


%   Extract files

out  = dir(fromPath);
indx = ~[out.isdir] & ~ismember({out.name}, Exclusions);
out  = out(indx);
out  = {out.name};

%   copy files
    from = cellfun(@(x) fullfile(fromPath,  x), out, 'UniformOutput', false);
    to   = cellfun(@(x) fullfile(toPath,  x), out, 'UniformOutput', false);

    for j = 1:numel(from)
        [status,message,messageId] = copyfile(from{j}, to{j}, 'f');
    end

    %   Extract SubFolders

out  = dir(fromPath);
indx = [out.isdir] & ~ismember({out.name}, Exclusions);
out  = out(indx);
out  = {out.name};

%   Recusive Call

for i = 1:numel(out)
    fpath = fullfile(fromPath, out{i});
    tpath = fullfile(toPath, out{i});
    matpacks.iofun.(mfilename)(fpath, tpath);
end
