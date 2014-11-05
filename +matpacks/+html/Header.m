function out = bpHeader(htmlpath, title)

if nargin < 1 || isempty(htmlpath); htmlpath = 'c:\temp';               end
if nargin < 1 || isempty(htmlpath); title = 'NAGP Power Trading';       end
localpath = strrep(mfilename('fullpath'), mfilename, '');

matpacks.iofun.folderCheckCreate(fullfile(htmlpath, 'files'));


try
    [status message id] = copyfile(fullfile(localpath,'bplogo.png'), ...
        fullfile(htmlpath, 'files', 'bplogo.png'), 'f');

    out = strcat( ...
    '<div data-role="header">', ...
    ' <table style="width: 100%;" border = "1" cellspacing="5">', ...
    ' <tbody> <tr> ', ...
    ' <td style="text-align: center;" width="22%">', ...
    ' <a href="http://global.bpweb.bp.com/" target="_self"> ', ...
    ' <img border="0" width="54px" height="71px" src="', ...
    fullfile(htmlpath, 'files') , '\bplogo.png" alt="BP Logo"> ', ...
    '</a> </td> <td style="width: 78%; padding-left: 10px;"> <h1 align="center"> ', ...
    title, ...
    ' </td> </h1> </tr> </tbody>', ...
    ' </div>');

catch ME
    disp(ME.message);
    return;
end
end

%    '<html xmlns="http://www.w3.org/TR/REC-html40">', ...
%, ...
%'<body> <div id="header"> );

% '<title><span style=''mso-ignore:vglayout;', ...
%   'position:absolute;z-index:2;margin-left:0px;margin-top:0px;width:54px;', ...
%   'height:71px''><a href="http://global.bpweb.bp.com/" target="_self"><img', ...
%   'border=0 width=54 height=71 src="', fullfile(htmlpath/files) , '/"bplogo.png alt="BP Logo"', ...
%   'v:shapes="bpLogo"></a></span>', ...