function b = boundingbox_operation(domain1,domain2,operation)
% FUNCTION NAME:
%   boundingbox_operation.
% 
% DESCRIPTION:
%   This function performs the given set operation between two domains  
%   (modelled using define_domain routine) and compute the bounding
%   box that contains the final domain.
%
% INPUT:
%   domain1 - (struct) first domain;
%   domain2 - (struct) second domain;
%   operation - (string) set operation we want to perform
%   'U': union, 'I':intersection, 'D': difference.
%
% OUTPUT:
%   b - (polyshape) polyshape object that has the vertices of the resulting
%   bounding box.
%
% AUTHOR: M.Santoro.
% LAST UPDATE: 02/13/2024.

    % DETERMINING LIMITS OF FIRST DOMAIN BOUNDING BOX
    a1 = min(domain1.bounding_box.Vertices(:,1)); b1 = max(domain1.bounding_box.Vertices(:,1));
    c1 = min(domain1.bounding_box.Vertices(:,2)); d1 = max(domain1.bounding_box.Vertices(:,2));
    % DETERMINING LIMITS OF SECONDO DOMAIN BOUNDING BOX
    a2 = min(domain2.bounding_box.Vertices(:,1)); b2 = max(domain2.bounding_box.Vertices(:,1));
    c2 = min(domain2.bounding_box.Vertices(:,2)); d2 = max(domain2.bounding_box.Vertices(:,2));
    % DETERMINING LIMITS OF FINAL BOUNDING BOX
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