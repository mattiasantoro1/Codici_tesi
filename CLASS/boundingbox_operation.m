function b = boundingbox_operation(class1,class2,operation)
% FUNCTION NAME:
%   boundingbox_operation.
% 
% DESCRIPTION:
%   This function performs the given set operation between two domains 
%   (modelled using disk, ellipse amd polygon classes) and compute the 
%   final bounding box.
%
% INPUT:
%   class1 - first domain;
%   class2 - second domain;
%   operation - (string) set operation we want to perform
%   'U': union, 'I':intersection, 'D': difference.
%   NOTE: class1 and class2 are instances of either disk, ellipse or
%   polygon class.
%
% OUTPUT:
%   b - (polyshape) polyshape object that has the vertices of the resulting
%   bounding box.
%
    % FIRST INSTANCE BOUNDING BOX PARAMETERS
    a1 = min(class1.bounding_box.Vertices(:,1)); b1 = max(class1.bounding_box.Vertices(:,1));
    c1 = min(class1.bounding_box.Vertices(:,2)); d1 = max(class1.bounding_box.Vertices(:,2));
    % SECOND INSTANCE BOUNDING BOX PARAMETERS
    a2 = min(class2.bounding_box.Vertices(:,1)); b2 = max(class2.bounding_box.Vertices(:,1));
    c2 = min(class2.bounding_box.Vertices(:,2)); d2 = max(class2.bounding_box.Vertices(:,2));
    % FINAL BOUNDING BOX PARAMETERS
    switch operation
        case 'U'
            % UNION
            xlimit = [min(a1,a2) max(b1,b2)];
            ylimit = [min(c1,c2) max(d1,d2)];
        case 'I'
            % INTERSECTION
            xlimit = [max(a1,a2) min(b1,b2)];
            ylimit = [max(c1,c2) min(d1,d2)];
        case 'D'
            % DIFFERENCE
            xlimit = [a1 b1];
            ylimit = [c1 d1];
    end
    % COMPUTING FINAL BOUNDING BOX
    b = polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1)],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
end