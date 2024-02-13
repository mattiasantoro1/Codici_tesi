
function [T,w,res,mom]=cqmc_01(deg,X,tol,nest,comp_type)

%--------------------------------------------------------------------------
% Object
%--------------------------------------------------------------------------
% The routine computes a Compressed Quasi-Monte Carlo formula from a large
% low-discrepancy sequence on a low-dimensional compact set preserving the
% QMC polynomial moments up to a given degree, via Tchakaloff sets and NNLS
% moment-matching.
%--------------------------------------------------------------------------
% INPUT:
%--------------------------------------------------------------------------
% deg: polynomial degree
% X: d-column array of a low-discrepancy sequence
% tol: moment-matching residual tolerance
% nest:  nesting parameter.
%     If 0 all the initial Halton points are considered at the first stage.
%     If 1, smaller sets of increasing dimensions are considered along an
%     iteration process.
% comp_type: compression algorithm. 1: lsqnonneg 2: LHDM. 3: LHDMv4.
%--------------------------------------------------------------------------
% OUTPUT:
%--------------------------------------------------------------------------
% T: compressed points (subset of X).
% w: positive weights (corresponding to T).
% res: moment-matching residual
% moms: monents of a certain shifted tensorial Chebyshev basis (total
%   degree equal to deg).
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


N=length(X(:,1));

if N <= 0, 
    fprintf(2,'\n \t No point in domain ');
    T=[]; w=[]; res=[]; mom=[]; LHDM_stats=[]; return; 
end

% 1.2: Chebyshev-Vandermonde matrix of degree deg at X
V=dCHEBVAND(deg,X);
% 1.3: QMC moments
mom=V'*ones(N,1)*1/N;
% 1.4: dimension of the polynomial space
r=length(V(1,:));
% 2: computing the compressed QMC formula
% 2.1: initializing the candidate Tchakaloff set cardinality
if nest==1
    k=4*r;
else
    k=N;
end
% 2.2: initializing the residual
res=2*tol;
% 2.3: increase percentage of a candidate Tchakaloff set
theta=1;
% iterative search of a Tchakaloff set by NNLS moment-matching
s=1;

while res(end)>tol && k<=N
    % 2.4: d-variate full-rank Chebyshev-Vandermonde matrix at X(1:k,:);
    U=V(1:k,:);
    % 2.5: polynomial basis discrete orthogonalization
    [Q,R]=qr(U,0);
    % 2.6: orthogonal moments
    orthmom=(mom'/R)';
    
    % 2.7: nonnegative weights by NNLS
    switch comp_type
        case 1
            % fprintf('\n \t -> lsqnonneg');
            [w,resnorm] = lsqnonneg(Q',orthmom);
        case 2
            % fprintf('\n \t -> LHDM');
            [w,resnorm,exit_flag,iter] = LHDM(Q',orthmom);
        case 3
            % fprintf('\n \t -> LHDM_v4');
            [w,resnorm,~,iter] = LHDM_v4(Q',orthmom);
    end
    
    % 2.8: moment-matching residual
    res(s)=norm(U'*w-mom);
         
%    fprintf('\n \n \t sum(w)     : %1.15e',sum(w))
%    fprintf('\n \t sum(abs(w)): %1.15e',sum(abs(w)))
%    negW=find(w < 0);
%    fprintf('\n \t #neg(w): %6.0f',length(negW))
%    fprintf('\n \t exit_flag: %1.0f',exit_flag)
     
    % 2.9: updating the candidate Tchakaloff set cardinality
    k=floor((1+theta)*k);
    
    if sign(sum(abs(w))-sum(w)) > 0, res(s)=realmax; end
    
    s=s+1;
end % while

% compressed formula
% 2.10: indexes of the positive weights
ind=find(w>0);
% 2.11: compressed support points selection
T=X(ind,:);
% 2.12: corresponding positive weights
w=w(ind);

