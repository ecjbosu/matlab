function deepaddpath(PathName, JavaFlag)

%DEEPADDPATH    Recursively adds the given pathname and its subfolders

%   Persistent Variables

persistent Exclusions

if isempty(Exclusions)
    if strcmp(computer, 'PCWIN')
        Exclusions = {'exclusions', 'win64' '.' '..' '.svn', 'docx' };
    else
        Exclusions = {'exclusions', 'win32' '.' '..' '.svn', 'docx'};
    end
end

%   Parse Inputs

if nargin < 1 || isempty(PathName); error('Missing required input:  PathName'); end
if nargin < 2 || isempty(JavaFlag); JavaFlag = false;                           end

%   Error Checking

if ~isscalar(JavaFlag) && islogical(JavaFlag);  error('Invalid Input:   JavaFlag must be a scalar logical');    end
if ~ischar(PathName);                           error('Invalid Input:   PathName must be a char');              end

%   Return (if Package)

if ~isempty(regexp(PathName, '+', 'once'))
    return
end

%   Determine Function

% if JavaFlag
%     AddPathFcn = @javaaddpath;
%     disp(['Adding java path: ' PathName])
% else
    disp(['Adding path: ' PathName])
    AddPathFcn = @addpath;
% end

%   Add PathName

AddPathFcn(PathName)

%   Extract SubFolders

out  = dir(PathName);
indx = [out.isdir] & ~ismember({out.name}, Exclusions);
out  = out(indx);
out  = {out.name};

%check Java on root jar classpath
if JavaFlag
    jout = dir(PathName);
    isdir = [jout.isdir];
    indx =  ~isdir & ~ismember({jout.name}, Exclusions);
    jout  = jout(indx);
    jout  = {jout.name};
    for j = 1:numel(jout)
        disp(['Adding java path: ' jout{j}])
        javaaddpath(fullfile(PathName, jout{j}));
    end
end
%   Recusive Call

for i = 1:numel(out)
    tpath = fullfile(PathName, out{i});
    gist.environment.(mfilename)(tpath)
    %check java on recursive paths
    if JavaFlag
        jout = dir(tpath);
        isdir = [jout.isdir];
        indx =  ~isdir & ~ismember({jout.name}, Exclusions);
        jout  = jout(indx);
        jout  = {jout.name};
        for j = 1:numel(jout)
        disp(['Adding java path: ' jout{j}])
            javaaddpath(fullfile(tpath, jout{j}));
        end
    end
end
