function out = validgloballocations

%VALIDGLOBALLOCATIONS   Returns the valid environment global locations
%
%   The valid environment global locations refer to the properties of the global env 
%   variable that may be set:
 
try
    
    out = gist.environment.nargsin('System', mfilename);
    
catch ME
    
    warning(sprintf('Gist:environment:validgloballocatons: %s', 'Using predefined defaults'));
    out = {'Houston' 'Kilgore' 'Shreveport'};
    
end

end

