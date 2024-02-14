classdef disk
% This class is used to model a bivariate disk.
%
% PROPERTIES:
%   center - (array) 1x2 float array containing in sequence x and y
%   coordinates of the disk center;
%   radius - (float) disk radius;
%   bounding_box - (polyshape) polyshape instance that represents the
%   bounding box of a disk.
%
% METHODS (documentation can be found below)
%   disk: constructor;
%   in_domain: given a set of points to test, this function determines
%   which of them are in the disk or not;
%   plotdomain: given a disk instance, compute some points of its boundary.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/14/2024.

    properties
        center;
        radius;
        bounding_box;
    end
    
    methods
        function obj = disk(c,r)
        % Construct an instance of this class. If c and r are set, the
        % constructor creates a disk instance with center in c and
        % radius r. If none of them are set, this method constructs a disk
        % instance with center in (0,0) and radius 1 (default case)
            switch nargin
                case 0
                    % DEFAULT CASE
                    obj.center = [0 0];
                    obj.radius = 1;
                case 2
                    if r > 0
                    % Radius must be positive
                        obj.center = c;
                        obj.radius = r;
                    else
                        return
                    end
                otherwise
                    return
            end
            % CREATE BOUNDING BOX OF DISK INSTANCE
            xlimit = [obj.center(1)-obj.radius obj.center(1)+obj.radius];
            ylimit = [obj.center(2)-obj.radius obj.center(2)+obj.radius];
            obj.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
        end
        
        function bool = in_domain(points,obj)
        % INPUT:
        %   points - (matrix) Nx2 matrix whose rows contain in sequence x
        %   and y coordinates of the test points. 
        %   
        % OUTPUT
        %   bool - (array) 1xN logical array. In particular:
        %       0: point is out the disk, 1: point is in the disk.
            bool = ((points(1,:) - obj.center(1)).^2 + (points(2,:) - obj.center(2)).^2 < obj.radius ^2);
        end
        
        function [x,y] = plotdomain(obj)
        % OUTPUT:
        %   x - (array) x-coordinates points.
        %   y - (array) y-coordinates points.
            t=-pi:0.01:pi;
            x = obj.center(1)+obj.radius*cos(t);
            y = obj.center(2)+obj.radius*sin(t);
        end
    end
end