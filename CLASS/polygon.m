classdef polygon
% This class is used to model a plane polygon.
%
% PROPERTIES:
%   vertices - (matrix) Nx2 matrix containing counterclockwise in sequence 
%   x and y coordinates of the polygon. Note that first and last entries
%   do not have to be the same;
%   bounding_box - (polyshape) polyshape instance that represents the
%   bounding box of a polygon.
%
% METHODS (documentation can be found below)
%   polygon: constructor;
%   in_domain: given a set of points to test, this function determines
%   which of them are in the polygon or not;
%   plotdomain: given a polygon instance, compute some points of its
%   boundary.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/13/2024.
    
    properties
        vertices
        bounding_box;
    end
    
    methods
        function obj = polygon(v)
        % Construct an instance of this class. If v is set, the
        % constructor creates a disk instance whose vertices are the 
        % entries of v. Otherwise, this method constructs the unitary 
        % square (default case)
            switch nargin
                case 0
                    obj.vertices = [0 0; 1 0; 1 1; 0 1];
                case 1
                    obj.vertices = v;
            end
            % CREATE BOUNDING BOX OF POLYGON INSTANCE
            xlimit = [min(obj.vertices(:,1)) max(obj.vertices(:,1))];
            ylimit = [min(obj.vertices(:,2)) max(obj.vertices(:,2))];
            obj.bounding_box = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
        end
        
        function bool = in_domain(points,obj)
        % INPUT:
        %   points - (matrix) Nx2 matrix whose rows contain in sequence x
        %   and y coordinates of the test points. 
        %   
        % OUTPUT
        %   bool - (array) 1xN logical array. In particular:
        %       0: point is out the polygon, 1: point is in the polygon.
            pol = polyshape(obj.vertices);
            bool = [];
            for p=points
                bool(end+1) = isinterior(pol,p(1),p(2));
            end
        end
        
        function [x,y] = plotdomain(obj)
        % OUTPUT:
        %   x - (array) x-coordinates points;
        %   y - (array) y-coordinates points.
            t=0:0.1:1;
            s = size(obj.vertices);
            x = []; y = [];
            for i = 1:1:s(1)-1
                x = [x t*obj.vertices(i+1,1)+(1-t)*obj.vertices(i,1)];
                y = [y t*obj.vertices(i+1,2)+(1-t)*obj.vertices(i,2)];
            end
            x = [x t*obj.vertices(1,1)+(1-t)*obj.vertices(i+1,1)];
            y = [y t*obj.vertices(1,2)+(1-t)*obj.vertices(i+1,2)];
        end
    end
end

