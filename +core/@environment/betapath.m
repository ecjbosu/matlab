function out = betapath(GlobalLocation)

%BETAPATH   Returns the scenario path name

if nargin < 1 || isempty(GlobalLocation); GlobalLocation = gist.environment.globallocation; end

tpath = 'beta';
    
switch  lower(GlobalLocation)
    
    case    'houston'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
    
    case    'kilgore'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
        
    case    'shreveport'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
        
    otherwise
        
        error(['Unrecognized Global Location: ' GlobalLocation]);
        
end