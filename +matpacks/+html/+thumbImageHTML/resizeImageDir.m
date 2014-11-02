function resizeImageDir(DirName,DirName2,newName,preferredW, imageType)

% function for resizing the jpeg files stored in a directory:
% DirName: the folder in which the images are stored.
% DirName2: the folder in which the thumbnails will be stored.
% newName: a string to be added in front of all fileNames for the thumbnail
% files
% imageType: type of image to be processed (jpg, png)
% preferredW: preferred width of the thumbnails

D = dir([DirName '/*.' imageType]);
warning off;
count = 1;
for (i=3:length(D))
        fprintf('Processing file %s...',D(i).name);
        %resizeJPG(sprintf('%s\\%s.jpg',DirName,D(i).name(1:end-4)),sprintf('%s\\%s%d.jpg',DirName,newName,count),1);
        if (strcmp(newName,'')~=1)            
            newFileName = [DirName '/' DirName2 '/' newName D(i).name(1:end-4) '.' imageType];
        else % replace:                      
            newFileName = [DirName '/' DirName2 '/' D(i).name(1:end-4) '.' imageType];            
        end   
        spstr = ['%s/%s.' imageType];
        matpacks.html.thumbImageHTML.resizeJPG(sprintf(spstr, DirName,D(i).name(1:end-4)),newFileName,preferredW, imageType);
        fprintf('\n');
        count = count + 1;
end