function [ status, message, messageId ] = fileCheckCopy( filenm )
%FILECHECKCOPY check folder exists
%   Detailed explanation goes here
%   Help function to check and create a directory

%% check folder exists
%TODO: convert  throwing a warning and continuing.  Let the calling
%class/function handle the error.
status = 0; 
message = [];
messageId = [];
    
if exist(filenm,'file')
    
    % get previous file and rename with datestamp
    
    [pathstr, name, ext] = fileparts(filenm);
    dirs = dir(pathstr);
    dirs = dirs(~[dirs.isdir]); %drop directories
    
    %match the file name
    idx = strcmp({dirs.name}, [name ext]);
    
    to = fullfile(pathstr, [name '_' datestr([dirs(idx).datenum]', 'YYYY-mm-dd_HH_MM_ss') ext]);
    [status, message, messageId] = copyfile(filenm, to, 'f');
    
end
 
end

