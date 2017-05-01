function [newspace,Z]=LFDA(X,Y,r,kNN)
%
% Local Fisher Discriminant Analysis for Supervised Dimensionality Reduction
%
% Usage:
%       [T,Z]=LFDA(X,Y,r,metric)
%
% Input:
%    X:      d x n matrix of original samples     样本集 样本维度*样本数
%            d --- dimensionality of original samples
%            n --- the number of samples 
%    Y:      n dimensional vector of class labels  标签集样本数*1
%            (each element takes an integer between 1 and c, where c is the number of classes) 
%    r:      dimensionality of reduced space (default: d)  降维空间的维度（默认值d）
%    metric: type of metric in the embedding space (default:
%    'weighted')嵌入式空间矩阵的类型
%    
%            'weighted'        --- weighted eigenvectors 
%            'orthonormalized' --- orthonormalized
%            'plain'           --- raw eigenvectors
%    kNN:    parameter used in local scaling method (default: 7)
%
% Output:
%    T: d x r transformation matrix (Z=T'*X)
%    Z: r x n matrix of dimensionality reduced samples 
%
% (c) Masashi Sugiyama, Department of Compter Science, Tokyo Institute of Technology, Japan.
%     sugi@cs.titech.ac.jp,     http://sugiyama-www.cs.titech.ac.jp/~sugi/software/LFDA/

if nargin<2
  error('Not enough input arguments.')
end
[d n]=size(X);

if nargin<3
  r=d;
end

if nargin<4
%   kNN=7;
    kNN=1;
end

tSb=zeros(d,d);
tSw=zeros(d,d);

for c=1:max(Y)
  Xc=X(:,Y==c);
  nc=size(Xc,2);

  % Define classwise affinity matrix
  Xc2=sum(Xc.^2,1);
  distance2=repmat(Xc2,nc,1)+repmat(Xc2',1,nc)-2*Xc'*Xc;
  [sorted,index]=sort(distance2);
  kNNdist2=sorted(kNN+1,:);
  sigma=sqrt(kNNdist2);
  localscale=sigma'*sigma;
  flag=(localscale~=0);
  A=zeros(nc,nc);
  A(flag)=exp(-distance2(flag)./localscale(flag));

  Xc1=sum(Xc,2);
  G=Xc*(repmat(sum(A,2),[1 d]).*Xc')-Xc*A*Xc';
  tSb=tSb+G/n+Xc*Xc'*(1-nc/n)+Xc1*Xc1'/n;
  tSw=tSw+G/nc;
end

X1=sum(X,2);
tSb=tSb-X1*X1'/n-tSw;

tSb=(tSb+tSb')/2;
tSw=(tSw+tSw')/2;


[V,L]=eig(tSb,tSw);
[L,index]=sort(diag(L));%求以L为对角的对角矩阵
V=V(:,index);
index=find(L>1.e-5);%找到大于0的该矩阵的下标

L=L(index(end-r+1:end));
newspace=V(:,index(end-r+1:end));%有意义的特征值所对应的特征向量

Z=newspace'*X;

% % tSw=tSw+eye(size(tSw,1))*1.e-8;
% % %Sw=reshape(Sw,10,10);
% % %求最大特征值和特征向量
% % %[V,L]=eig(inv(Sw)*Sb);
% % S=inv(tSw)*tSb;
% % S=(S+S')/2;
% % [V, L] = eig(S);
% % %V=V(:,condition);
% % [L,index]=sort(diag(L));%求以L为对角的对角矩阵
% % V=V(:,index);
% % index=find(L>1.e-5);%找到大于0的该矩阵的下标
% % % T0=eigvec(:,sort_eigval_index(end:-1:1));
% % 
% % L=L(index(end-r+1:end));
% % newspace=V(:,index(end-r+1:end));%有意义的特征值所对应的特征向量
% % % T0=eigvec(:,sort_eigval_index(end:-1:1));
% % 
% % Z=newspace'*X;

% tSw=tSw+eye(size(tSw,1))*1.e-8;
% %求最大特征值和特征向量
% S=inv(tSw)*tSb;
% S=(S+S')/2;
% [V, L] = eig(S);






