function deepcopypath(fromPath, toPath)

%deepcopypath    Recursively copies the directory structure the given 
%pathname and its subfolders.  Okay, not a real copy, but reads the
%directory structure and executes a mkdir with toPath as the parent.
%Example: 
%matpacks.iofun.deepcopypath('i:\ngg\ISTDCT\NAGP_Market_Risk\TST\Power', 'i:\ngg\ISTDCT\NAGP_Market_Risk\TST\PowerOPT')
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
    disp(['Copying path: ' fromPath ' to ' toPath])
    AddPathFcn = @matpacks.iofun.folderCheckCreate;

%   Add PathName

AddPathFcn(toPath);

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
