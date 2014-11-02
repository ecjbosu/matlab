classdef iofun 
%iofun Input/Output functions

    methods (Static)
        
        out = folderCheckCreate( folder );
        out =  sendolmail(to,subject,body,attachments);
        [success,theMessage] = xlswrite(file,data,sheet,range);
        status  = fileDelete( in )
        deepcopypath(fromPath, toPath)
        deepcopyfile(fromPath, toPath)
        sendmail(to,subject,theMessage, subtype, attachments)
        
    end

end