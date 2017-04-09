clear all;
n1a=3;
n1b=3;
n2=3;
X1a=[randn(2,n1a).*repmat([1;2],[1 n1a])+repmat([-6;0],[1 n1a])];
X1b=[randn(2,n1b).*repmat([1;2],[1 n1b])+repmat([ 6;0],[1 n1b])];
X2= [randn(2,n2 ).*repmat([1;2],[1 n2 ])+repmat([ 0;0],[1 n2 ])];
X=[X1a X1b X2];
Y=[ones(n1a+n1b,1);2*ones(n2,1)];

[T,Z]=SparseLocal_FDA(X,Y,2);