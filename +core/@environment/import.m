function import(full)

%import Initializes the gist platform import
%Parameters:
%   full: import all packages in working directory
%       false: import only core

%   Parse Inputs

if nargin < 1 || isempty(full);       full = true;                      end

if full
       %   Import Packages

    packages       = dir(pwd);
    packages       = {packages.name};
    packages       = packages(~cellfun(@isempty,regexp(packages, '+')));
    
else
   
    %only the core gist packages imported othere imported as needed
    packages = {'+apps' '+gist' '+matlab' '+security'};
    
end

% execute imports
    for i = 1:numel(packages)
        disp(['Importing Package: ' packages{i}])
        import([packages{i}(2:end) '.*'])
    end
    
