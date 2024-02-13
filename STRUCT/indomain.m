function inside = indomain(points,domain)
% FUNCTION NAME:
%   indomain.
% 
% DESCRIPTION:
%   this function determines if some points are in a domain.
%
% INPUT:
%   points: 2xN matrix containing the points we want to test;
%   domain - (struct) set of variables that parameterizes the bivariate
%   domain (modelled using define_domain routine).
%
% OUTPUT:
%   inside: logical array that has as many entry as the tested point. In particular:
%       0: point is out of the domain, 1: point is in the domain.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/13/2024

% PREALLOCATING IN-DOMAIN ARRAY
inside = [];
switch domain.name
    case 'disk'
        for p=points
            if (p(1)-domain.center(1))^2 + (p(2)-domain.center(2))^2 < domain.radius^2
                inside(end+1) = 1;
            else
                inside(end+1) = 0;
            end
        end
    case 'ellipse'
        for p=points
            if (p(1)-domain.center(1))^2/domain.a^2 + (p(2)-domain.center(2))^2/domain.b^2 < 1
                inside(end+1) = 1;
            else
                inside(end+1) = 0;
            end
        end
    case 'polygon'
        polygon = polyshape(domain.vertices(:,1),domain.vertices(:,2));
        inside = isinterior(polygon,points(1,:),points(2,:))';
end