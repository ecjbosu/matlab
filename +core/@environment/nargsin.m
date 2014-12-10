function  out = nargsin( KeyMaster, mfile, narg, varargin )
%NARGSIN will retrieve the default nargin from 
%   defaultDB:
%
% vargin is a list of additional parameters return as specified in the
% metadata.


if nargin < 2
    error('gist:environment:nargsin: %s','KeyMaster and CodeName required');
end

%only reference defaultDB
link = links.dbmart('defaultDB', KeyMaster, mfile);
link = link.dataset;

if nargin < 3
    idx  = strcmpi(link.CodeName, mfile);
else
    
    %find the matching Series ID with narg
    %check if numeric or string seriesIDs
    if isnumeric(narg)
        idx  = strcmpi(link.CodeName, mfile) & strcmpi(link.SeriesID, num2str(narg));
    elseif ischar(narg) || iscellstr(narg)
        idx  = strcmpi(link.CodeName, mfile) & strcmpi(link.SeriesID, narg);
    else
        error('gist:environment:nargsin: %s','Invalid narg input parameter (numeric, char or cellstring required).');
    end
end

out  = link.ObservationDefault(idx);

% Handle the varargin keys Note that each vararin is referenced of narg
% index since the vararing is a cellarray.

if ~isempty(varargin)

    % reset out to a structure
    out.ObservationDefault = out ;
    
    % loop over varargin and return structure of parameters requested
    for i=1:numel(varargin)
        out.(varargin{i}) = link.(varargin{i}){idx};
    end
    
end

