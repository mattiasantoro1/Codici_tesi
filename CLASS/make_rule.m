function [T,w,XY,W,res,moms,box,cpus,vol]=make_rule(deg,...
    domain1,domain2,operation_parm,card,tol,XY)

%--------------------------------------------------------------------------
% Object
%--------------------------------------------------------------------------
% * Computation of cubature rules on a 2D domain "Omega" obtained by set
% operations between piecewise NURBS domains.
% * The routine computes a Compressed Quasi-Monte Carlo formula from a large
% low-discrepancy sequence on a low-dimensional compact set preserving the
% QMC polynomial moments up to a given degree, via Tchakaloff sets and NNLS
% moment-matching.
%--------------------------------------------------------------------------
% Input
%--------------------------------------------------------------------------
% deg: QMC degree of precision.
% geometry_NURBS1: geometry NURBS domain 1 (see how to define them in demo).
% geometry_NURBS2: geometry NURBS domain 2 (see how to define them in demo).
% operation_parm: it sets the operation between domains, defining the final
%      domain "Q" as "Q=operation(P,S)"
%      1. union, 2. intersection, 3. diff, 4. symm. diff.
% card: cardinality of Halton points in the bounding box of the domain "Q"
% Nbox: technical parameter for indomain routine; in doubt set 100.
% safe_mode: in the indomain routine one must be certain that points are
%      inside the domain. In our cubature needs we just wants some points
%      in the domain. Consequently, if we are not fully sure that a point
%      is in the domain, due to geometrical issues, we do not take it into
%      account.
% nest:  nesting parameter.
%     If 0 all the initial Halton points are considered at the first stage.
%     If 1, smaller sets of increasing dimensions are considered along an
%     iteration process.
% comp_type: compression algorithm. 1: lsqnonneg 2: LHDM. 3: LHDMv4
% tol: compression tolerance.
% XY: initial quasi montecarlo points in the final integration domain (if
%      already available). It is an N x 2 matrix of coordinates XY;
%      (variable not mandatory).
% bbox: bounding box of the final domain it is a matrix 2 x 2. It is of the
%      form "bbox=[a c; b d]" where the bounding box is
%       [a,b] x [c,d]  (variable not mandatory).
% f: function of variables x,y we want to integrate
%--------------------------------------------------------------------------
% Output
%--------------------------------------------------------------------------
% T,w: compressed rule via its nodes T, stored as an Mx3 matrix of
%     coordinates and weights (vector M x 1).
% XY,W: full rule via its nodes XY, stored as an Nx3 matrix of
%     coordinates and weights (vector N x 1).
% res: moment residuals
% moms: QMC moments up to total degree "deg" of a certain tensorial
%     Chebyshev basis.
% bbox: bounding box of the final domain it is a matrix 2 x 3; variable not
%      mandatory.
% cpus: cputimes of determining the full rule with nodes XY and the
%       compressed one.
% vol: domain volume
%--------------------------------------------------------------------------
% 0. TROUBLESHOOTING.
%--------------------------------------------------------------------------
if nargin < 4, operation_parm='U'; end
if nargin < 5, card=10^6; end
%if nargin < 6, nest=1; end
%if nargin < 7, comp_type=2; end
if nargin < 6, tol=e-10; end
if nargin < 7, XY=[]; end

%--------------------------------------------------------------------------
% 1. DEFINE BOUNDING BOXES USING BUILT-IN FUNCTIONS
%--------------------------------------------------------------------------
box = boundingbox_operation(domain1,domain2,operation_parm);
a=min(box.Vertices(:,1)); b=max(box.Vertices(:,1));
c=min(box.Vertices(:,2)); d=max(box.Vertices(:,2));
%--------------------------------------------------------------------------
% 2. PERFORM CUBATURE ON UNION OF THE DOMAINS.
%--------------------------------------------------------------------------

% ................. Computation Halton set in domain  .....................

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
    inside1=in_domain(H0',domain1);
    inside2=in_domain(H0',domain2);
    
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

% ............... Computation compressed set in domain  ...................
tic;
area_bbox=abs(b-a)*abs(d-c); % area bounding box
vol=area_bbox*size(XY,1)/card;

W=vol/size(XY,1);

%routine_vers=1;
%switch routine_vers
    %case 1
        [T,w,res,moms]=cqmc(deg,XY,tol);
        w=w*vol; % scale weights
        moms=moms*vol; % scale moments
    %case 2
        %[T,w,res,moms]=cqmc_02(deg,XY,vol,tol,nest,comp_type);
%end
cpus(2)=toc;