function domain = define_domain(type,varargin)
% FUNCTION NAME:
%   define_domain.
% 
% DESCRIPTION:
%   define a bivariate domain: disk, ellipse or polygon.
%
% INPUT:
%   type - (string) name of the domain. Up to now there are three options:
%   'disk','ellipse','polygon' if respectively a disk, ellipse, polygon is
%   needed to be defined;
%   varargin - (cell) set of parameters useful to define domain.
%
% OUTPUT:
%   domain - (struct) bivariate domain containing all the variables useful
%   for its definition and its bounding box.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/13/2024.

    if nargin == 0
        return
    end

    switch lower(type)
        case 'disk'
            % DISK
            domain.name = 'disk';
            if nargin == 1 
                % DEFAULT DISK
                domain.center = [0 0];
                domain.radius = 1;
            else
                if nargin == 3 && length(varargin{1}) == 2 && isnumeric(varargin{1}) ...
                        && isnumeric(varargin{2})
                    % USING ARGUMENTS TO MODEL A DISK
                    domain.center = varargin{1};
                    domain.radius = varargin{2};
                else
                    return
                end
            end
            % DEFINING BOUNDING BOX
            xlimit = [domain.center(1)-domain.radius domain.center(1)+domain.radius];
            ylimit = [domain.center(2)-domain.radius domain.center(2)+domain.radius];
            domain.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);

        case 'ellipse'
            % ELLIPSE
            domain.name = 'ellipse';
            if nargin == 1
                domain.center = [0 0];
                % DEFAULT ELLIPSE
                domain.a = 2;
                domain.b = 1;
                
            else
                if nargin == 4 && length(varargin{1}) == 2 && isnumeric(varargin{1}) ...
                        && isnumeric(varargin{2}) && isnumeric(varargin{3})                    
                    % USING ARGUMENTS TO MODEL AN ELLIPSE
                    domain.center = varargin{1};
                    domain.a = varargin{2};
                    domain.b = varargin{3};
                else
                    return
                end
            end
            % DEFINING BOUNDING BOX
            xlimit = [domain.center(1)-domain.a domain.center(1)+domain.a];
            ylimit = [domain.center(2)-domain.b domain.center(2)+domain.b];
            domain.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
            
        case 'polygon'
            % POLYGON
            domain.name = 'polygon';
            if nargin == 1
                % DEFAULT POLYGON
                domain.vertices = [0 0; 1 0; 1 1; 0 1];
                
            else
                s = size(varargin{1});
                if nargin == 2 && isnumeric(varargin{1}) && s(1) >= 3 && s(2) == 2
                    % USING ARGUMENTS TO MODEL A POLYGON
                    domain.vertices = varargin{1};
                else
                    return
                end
            end
            % DEFINING BOUNDING BOX
            xlimit = [min(domain.vertices(:,1)) max(domain.vertices(:,1))];
            ylimit = [min(domain.vertices(:,2)) max(domain.vertices(:,2))];
            domain.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
            
    otherwise
        return
    end
end