function [x,y] = plotdomain(domain)
% FUNCTION NAME:
%   plotdomain.
% 
% DESCRIPTION:
%   This function provides some points that belong to the boundary of a
%   given domain.
%
% INPUT:
%   domain - (struct) bivariate domain modelled using define_domain
%   routine.
%
% OUTPUT:
%   x - (array) x-coordinates points;
%   y - (array) y-coordinates points.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/10/2024.

    % PREALLOCATING BOUNDARY POINTS COORDINATES
    x = []; y = [];
    switch domain.name
        case 'disk'
            t=-pi:0.01:pi;
            x = domain.center(1)+domain.radius*cos(t);
            y = domain.center(2)+domain.radius*sin(t);
        case 'ellipse'
            t=-pi:0.01:pi;
            x = domain.center(1)+domain.a*cos(t);
            y = domain.center(2)+domain.b*sin(t);
        case 'polygon'
            t=0:0.1:1;
            s = size(domain.vertices);
            for i = 1:1:s(1)-1
                x = [x t*domain.vertices(i+1,1)+(1-t)*domain.vertices(i,1)];
                y = [y t*domain.vertices(i+1,2)+(1-t)*domain.vertices(i,2)];
            end
            x = [x t*domain.vertices(1,1)+(1-t)*domain.vertices(i+1,1)];
            y = [y t*domain.vertices(1,2)+(1-t)*domain.vertices(i+1,2)];
    end
end