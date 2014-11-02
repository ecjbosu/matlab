function createIndextable(Dir,HtmlName, TSize, imagesPerRow, imageType)

%
% function createThumbnailTable(Dir,HtmlName, TSize, imagesPerRow)
% 
% This function generates an html file that contains a table with
% thumbnails (and respective links) of the images stored in a provided
% directory.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% ARGUMENTS:
%  - Dir: the directory name in which the images are stored
%  - HtmlName: the name of the html file to be generated
%  - TSize: The size (in pixels) of the thumbnails images to be generated (the largest
%           of the two dimensions (width or height), depending on the image
%           orientation
%  - imagesPerRow: The number of thumbnails per row in the html page.
%  - imageType: the type of image (jpg, png, etc)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
%
% % % % % % % % % % % % % % % % % % % % % % % %
% Theodoros Giannakopoulos
% Dep. of Informatics and Telecommunications
% University of Athens
% http://www.di.uoa.gr/~tyiannak
% % % % % % % % % % % % % % % % % % % % % % % %

% generate thumbnails:
% Dir2 = 'Thumbnails';
% matpacks.iofun.folderCheckCreate(fullfile(Dir, Dir2));
%mkdir(Dir,Dir2);
% matpacks.html.thumbImageHTML.resizeImageDir(Dir,Dir2,'ThumbNail_',TSize, imageType);

D = dir([Dir '/*.' imageType]);

%remove dirs
D = D(~[D.isdir]);
%remove html
[~,idx] = regexp({D.name}, 'htm', 'match');
idx =  cellfun(@isempty, idx);
D = D(idx);


HtmlName = [HtmlName '.html'];
numOfCells = 0;

% Start writing the html file:
fp = fopen(fullfile(Dir,HtmlName),'wt');
fprintf(fp,'<html>\n');
fprintf(fp,'<body bgcolor="aaccdd">\n');

fprintf(fp,'<p align = ''center''><font size = "4" color = "003388">Index to the images in the folder <b>''%s''</b></font>\n',Dir);

fprintf(fp,'<table width="100%%" border="1" cellpadding="0">\n');
for (i=1:length(D))            
    curFileName = D(i).name;
%     curThumbName = ['ThumbNail_' D(i).name];
     if (mod(numOfCells, imagesPerRow)==0)
         if (numOfCells>0)
             fprintf(fp, '</tr>\n');
         end
         fprintf(fp, '<tr>\n');
     end
    fprintf(fp, '  <td align = ''center''><font size = "3" color = "003388"> <a href = "%s" target = "new"> %s  </a> </td>\n',...
        curFileName, curFileName);
    numOfCells = numOfCells + 1;
end
if (numOfCells>0)
    fprintf(fp, '</tr>\n');
end
fprintf(fp,'</table>\n');

fprintf(fp,'</body>\n');
fprintf(fp,'</html>\n');
fclose(fp);

%open(fullfile(Dir,HtmlName));