function out = developmentpath(GlobalLocation)

%DEVELOPMENTPATH	Returns the development path name

if nargin < 1 || isempty(GlobalLocation); GlobalLocation = gist.environment.globallocation; end

% out = gist.environment.nargsin('System', GlobalLocation);
% out = fullfile(out, 'Development');

tpath = 'development';
    
switch  lower(GlobalLocation)
    
    case    'houston'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
    
    case    'kilgore'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
        
    case    'shreveport'
        
        out  = fullfile( getpref('Gist', 'rootSharePath'), 'dbMarts\', tpath);
        
    otherwise
        
        error(['Unrecognized Global Location: ' GlobalLocation])
        
end