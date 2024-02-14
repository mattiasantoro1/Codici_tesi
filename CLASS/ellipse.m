classdef ellipse
% This class is used to model a bivariate ellipse.
%
% PROPERTIES:
%   center - (array) 1x2 float array containing in sequence x and y
%   coordinates of the ellipse center;
%   a - (float) ellipse x-semiaxis;
%   b - (float) ellipse y-semiaxis;
%   bounding_box - (polyshape) polyshape instance that represents the
%   bounding box of an ellipse.
%
% METHODS (documentation can be found below)
%   ellipse: constructor;
%   in_domain: given a set of points to test, this function determines
%   which of them are in the ellipse or not;
%   plotdomain: given an ellipse instance, compute some points of its
%   boundary.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/14/2024.
    
    properties
        center;
        a;
        b;
        bounding_box;
    end
    
    methods
        function obj = ellipse(c,a,b)
        % Construct an instance of this class. If c,a,b are set, the
        % constructor creates an ellipse instance with center in c and
        % x,y-semiaxis respectively a,b. If none of them are set, this
        % method constructs an ellipse instance with center in (0,0) and 
        % x,y-semiaxis respectively 2,1 (default case)
            switch nargin
                case 0
                    obj.center = [0 0];
                    obj.a = 2;
                    obj.b = 1;
                case 3
                    % a,b must be positive
                    if a > 0 && b > 0
                        obj.center = c;
                        obj.a = a;
                        obj.b = b;
                    else
                        return
                    end
                otherwise
                    return
            end
            % CREATE BOUNDING BOX OF ELLIPSE INSTANCE
            xlimit = [obj.center(1)-obj.a obj.center(1)+obj.a];
            ylimit = [obj.center(2)-obj.b obj.center(2)+obj.b];
            obj.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
        end
        
        function bool = in_domain(points,obj)
        % INPUT:
        %   points - (matrix) Nx2 matrix whose rows contain in sequence x
        %   and y coordinates of the test points. 
        %   
        % OUTPUT
        %   bool - (array) 1xN logical array. In particular:
        %       0: point is out the ellipse, 1: point is in the ellipse.
            bool = ((points(1,:) - obj.center(1)).^2/obj.a ^2 + (points(2,:) - obj.center(2)).^2/obj.b ^2 < 1);
        end
        
        function [x,y] = plotdomain(obj)
        % OUTPUT:
        %   x - (array) x-coordinates points;
        %   y - (array) y-coordinates points.
            t=-pi:0.01:pi;
            x = obj.center(1)+obj.a*cos(t);
            y = obj.center(2)+obj.b*sin(t);
        end
    end
end