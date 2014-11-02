function status  = fileDelete( in )
%FILEDELETE delete file if exists
%   Detailed explanation goes here
%   BP Matlab help function to check and create a directory

%% delete file
%TODO: convert  throwing a warning and continuing.  Let the calling
%class/function handle the error.
        status = 0; 
        if exist(in,'file')
        %create directory
            try 
                delete(in);
                status = 0;
            catch exception
            %change to logger in the future
                status = 1;
                error([exception.identifier ': ' exception.message]); 
            end
        end
 
end

