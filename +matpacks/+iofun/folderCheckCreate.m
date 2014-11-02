function [ status ] = folderCheckCreate( folder )
%FOLDERCHECKCREATE check folder exists
%   Detailed explanation goes here
%   help function to check and create a directory

%% check folder exists
%TODO: convert  throwing a warning and continuing.  Let the calling
%class/function handle the error.
        status = 0; 
        if ~exist(folder,'dir')
        %create directory
            try 
                mkdir(folder);
                status = 0;
            catch exception
            %change to logger in the future
                status = 1;
                error([exception.identifier ': ' exception.message]); 
            end
        end
 
end

