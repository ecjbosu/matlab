function out = publish( data, filenm, varargin )
%PUBLISH overload the publish for matlab and displays the input parameter
%text

if nargin < 1 || isempty(data)
    error('matpacks:html:publish: %s', 'data is required');
end
if nargin < 2 || isempty(filenm)
    filenm = 'test';
end

%find outputDir
if ~ismember('outputDir', varargin)
    
    outDir = 'C:\temp';
    
else
    
    [~, idx]    = ismember('outputDir', varargin);
    outDir      = varargin{idx + 1};

end

    
% create temporary file
tempdir = 'C:\temp';
matpacks.iofun.folderCheckCreate(tempdir);

% ensure char array
if iscell(data)
    data = [data{:}];
end


%does not work so brute force using low level 

%fid = fopen(fullfile(tempdir, filenm), 'w');
%wrap in html attributes
% data = ['% ' data];
% fprintf(fid, '%s\n', '%% ');
% fprintf(fid, '%s\n', '% <html> ');
% fprintf(fid, '%s\n', lower(data));
% fprintf(fid, '%s\n', '% </html>');
% 
% fclose(fid)
% 
% out = publish(fullfile(tempdir, filenm), 'outputDir', outDir, ...
%     'format', 'html', 'evalCode', false, 'showCode', true);

% check sharepoint

    try
        matpacks.iofun.folderCheckCreate(outDir);

        %wrap in html attributes
        fid = fopen(fullfile(outDir, [filenm '.html']), 'w');
        fprintf(fid, '%s\n', '<html> ');
        fprintf(fid, '%s\n', data);
        fprintf(fid, '%s\n', '</html>');

        fclose(fid);
        out = data;
        
    catch ME
        
        disp(ME.message)
        gist.tools.stackTrace(ME);
        out = ME;
        
    end      

% matpacks.iofun.fileDelete(fullfile(tempdir, filenm));

end

