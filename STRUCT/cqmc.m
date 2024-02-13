
function [T,w,res,mom]=cqmc(deg,X,tol)

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
k=4*r;
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
    [w,resnorm,exit_flag,iter] = LHDM(Q',orthmom);
    
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

