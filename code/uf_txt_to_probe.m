function [geometry]=uf_txt_to_probe(filename);
%
% UF_TXT_TO_PROBE   Creates probe struct from probe text data file
%   function [probe]=uf_txt_to_probe(filename) returns a probe structure
%   that can be used for scan simulaton.  The string filename is the name
%   of a probe text file describing the geometric properties of the 
%   probe to be simulated.  The entries in the text file are in two
%   columns seperated by spaces, tabs, or an equal sign.  
%
%   Supported entries are
%       no_elements     Number of transducer elements
%       height          Elevational dimension of an individual element
%       width           Lateral dimension of an individual element
%       kerf            Space between elements
%       convex_radius   Radius of curlinear probe curvature (ignored for 
%                       other types) 
%       elv_focus       Depth of fixed focus supplied by transducer lens
%       probe_type      Types are 'linear','curvilinear', or 'phased'
%       no_sub_x        Number of mathematical elements per physical
%                       element, in lateral direction
%       no_sub_y        Same, elevational direction
%       f0              Transducer center frequency
%       bw              Fractional bandwidth, expressed as percentage of f0
%       phase           Phase of carrier relative to the pulse envelope
%       wavetype        'gaussian'
%
%   Other entries will be ignored with a warning.  Comments my be included
%   in the file by prefaceing with a % sign (Matlab style commenting)
%
% 10/21/2004, Stephen McAleavey, U. Rochester BME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% updated to now also scan for no_elements_[x,y] and kerf_[x,y] for the matrix probes
% Mark Palmeri (mlp6@duke.edu), 2012-10-11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This line reads the probe description file (not Siemens files, our own)
%The file is assumed to be contain parameters arranged in two columns, with
%the first col. being the parameter name and the second column the value.
%Comments may be inserted in the file in the matlab style (i.e. %=comment)
%spaces, tabs and equal signs may all be used to seperate columns.  See the
%case statement below for the parameter names 
% Deal with file-errors!!

% load geometry structure with json data
fid = fopen(filename);

% get text in json file into single string
probeJson = '';
line = fgetl(fid);
while ischar(line)
    probeJson = strcat(probeJson, line);
    line = fgetl(fid);
end

% convert to matlab struct from json data
geometry = fromjson(probeJson);

if ~isfield(geometry,'no_elements_x') && isfield(geometry,'no_elements');
    geometry.no_elements_x = geometry.no_elements;
end
if ~isfield(geometry,'no_elements_y');
    geometry.no_elements_y = 1;
end
if ~isfield(geometry,'width_x') && isfield(geometry,'width');
    geometry.width_x = geometry.width;
end
if ~isfield(geometry,'kerf_x') && isfield(geometry,'kerf');
    geometry.kerf_x = geometry.kerf;
end
if ~isfield(geometry,'width_y') && isfield(geometry,'height');
    geometry.width_y = geometry.height;
end
if ~isfield(geometry,'kerf_y') && isfield(geometry,'kerf');
    geometry.kerf_y = geometry.kerf;
end
