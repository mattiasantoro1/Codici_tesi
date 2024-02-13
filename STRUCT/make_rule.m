function [T,w,XY,W,res,moms,box,cpus,vol]=make_rule(deg,...
    domain1,domain2,operation_parm,card,tol,XY)

% FUNCTION NAME:
%   make_rule
% 
% DESCRIPTION:
%   this function computes a Compressed Quasi-Monte Carlo formula from a large
%   low-discrepancy sequence on a low-dimensional compact set preserving the
%   QMC polynomial moments up to a given degree, via Tchakaloff sets and NNLS
%   moment-matching.
%
% INPUT:
%   deg: QMC degree of precision.
%   domain1: struct containing useful parameters for defining the first domain
%   domain2: struct containing useful parameters for defining the second domain
%   operation_parm: it sets the operation between domains. In particular:
%      'U': union, 'I': intersection, 'D': difference.
%   card: cardinality of Halton points in the bounding box of the final domain
%   tol: compression tolerance.
%   XY: initial quasi montecarlo points in the final integration domain (if
%      already available). It is an N x 2 matrix of coordinates XY;
%      (variable not mandatory).
%
% OUTPUT:
%   T,w: compressed rule via its nodes T, stored as an Mx3 matrix of
%     coordinates and weights (vector M x 1).
%   XY,W: full rule via its nodes XY, stored as an Nx3 matrix of
%     coordinates and weights (vector N x 1).
%   res: moment residuals
%   moms: QMC moments up to total degree "deg" of a certain tensorial
%     Chebyshev basis.
%   box: bounding box of the final domain it is a matrix 2 x 3; variable not
%      mandatory.
%   cpus: cputimes of determining the full rule with nodes XY and the
%       compressed one.
%   vol: domain volume
%--------------------------------------------------------------------------
% Dates
%--------------------------------------------------------------------------
% First version: May 28, 2022;
% Checked: June 03, 2022.
%--------------------------------------------------------------------------
% Authors
%--------------------------------------------------------------------------
% G. Elefante, A. Sommariva, M. Vianello
%--------------------------------------------------------------------------
% Paper
%--------------------------------------------------------------------------
% "CQMC: an improved code for low-dimensional Compressed Quasi-MonteCarlo
% cubature"
% G. Elefante, A. Sommariva and M. Vianello
%--------------------------------------------------------------------------

% TROUBLESHOOTING
if nargin < 4, operation_parm='U'; end
if nargin < 5, card=10^6; end
if nargin < 6, tol=e-10; end
if nargin < 7, XY=[]; end

% DEFINE BOUNDING BOXES USING BUILT-IN FUNCTIONS
box = boundingbox_operation(domain1,domain2,operation_parm);
a=min(box.Vertices(:,1)); b=max(box.Vertices(:,1)); 
c=min(box.Vertices(:,2)); d=max(box.Vertices(:,2));

% PERFORM CUBATURE ON UNION OF THE DOMAINS

% Computation Halton set in domain
tic;

if isempty(XY)
    halton_pointset = haltonseq(card,2);
    H00=halton_pointset;
    
    % Scaling points
    H00x=H00(:,1); H00y=H00(:,2);
    H0=[a+H00x*(b-a) c+H00y*(d-c)];
    cpus(1)=toc; % Halton set generation
    
    % IN DOMAIN FUNCTIONS FOR BOTH DOMAINS
    tic;
    inside1=indomain(H0',domain1);
    inside2=indomain(H0',domain2);
    
    switch operation_parm
        case 'U'
            iok=find(inside1+inside2 >= 1);
        case 'I'
            iok=find((inside1+inside2) == 2);
        case 'D'
            iok=find(inside1 == 1 & inside2 == 0);
    end
    XY=H0(iok,:);
end

cpus(2)=toc; % Definition full QMC rule.

tic;
area_bbox=abs(b-a)*abs(d-c);    % area bounding box
vol=area_bbox*size(XY,1)/card;

W=vol/size(XY,1);   % QMC weights

%Computation CQMC rule
[T,w,res,moms]=cqmc(deg,XY,tol);
w=w*vol;    % scale weights
moms=moms*vol;  % scale moments
cpus(2)=toc;