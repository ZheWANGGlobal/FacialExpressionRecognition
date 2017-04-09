function [V,Z,X_tst]=SparseLocal_FDA(XXX,Y,x_tst,r,kNN,epsilon)
%
% 稀疏局部Fisher判别分析进行有监督降维度
%       
% 输入:
%    X:      d 乘 n 原始样本矩阵     
%            d --- 样本的维度（jaffe矩阵为64*64）
%            n --- 样本的个数（jaffe为213）
%    Y:      n 维样本标签集  
%    r:      降维空间的维度（默认值d）
%    kNN:    计算局部缩放邻接权值矩阵时要用到的最近邻参数(默认值 7)
%    epsilon:torlence  
% 输出:
%    V: d 乘 r 投影矩阵 (Z=T'*X)
%    Z: r 乘 n 降维后的样本矩阵 

XXX = double(XXX);

[d,n]=size(XXX);

if nargin<5
   kNN=2;
end

if nargin<4
  r=d;
end

tSb=zeros(d,d);%类间离散度矩阵
tSw=zeros(d,d);%类内离散度矩阵
W = ones(n)./n;
for c=1:max(Y)
  Xc=XXX(:,Y==c);
  Temp = find(Y==c);              
  nc=size(Xc,2); % 矩阵Xc的列数赋给nc

  % 计算权值矩阵A  LFDA采用局部缩放权值矩阵
  Xc2=sum(Xc.^2,1);
  distance2=repmat(Xc2,nc,1)+repmat(Xc2',1,nc)-2*Xc'*Xc;
  [sorted,index]=sort(distance2);
  kNNdist2=sorted(kNN+1,:);
  sigma=sqrt(kNNdist2);
  localscale=sigma'*sigma;
  flag=(localscale~=0);
  A=zeros(nc,nc);
  A(flag)=exp(-distance2(flag)./localscale(flag));
   
  W(Temp,Temp)=A./n;
  
  Xc1=sum(Xc,2);
  G=Xc*(repmat(sum(A,2),[1 d]).*Xc')-Xc*A*Xc';
  tSb=tSb+G/n+Xc*Xc'*(1-nc/n)+Xc1*Xc1'/n;
  tSw=tSw+G/nc;
end

%计算类间和类内离散度矩阵
X1=sum(XXX,2);
tSb=tSb-X1*X1'/n-tSw;

tSb=(tSb+tSb')/2;
tSw=(tSw+tSw')/2;

%计算混合离散度矩阵tSt
tSt = tSb+tSw;

Dlt = diag(sum(W));
Llt = Dlt - W;
[Qlt,Alpha]=eig(Llt);
Hlt = XXX*Qlt*abs(Alpha^(1/2));

%进行奇异值分解
% tHt = chol(tSt);    %R = chol(A) 满足R'*R = A.如果A不是正定，会报错
% tHt = tHt';
[P,~,~]=svd(Hlt);                                                                                      

Sb = P'*tSb*P;
Sw = P'*tSw*P;

%解决广义特征值问题并获得矩阵U
if r==d       %U=eigvec,D=eigval_matrix
  [U,D]=eig(Sb,Sw); %广义特征向量矩阵U和广义特征值矩阵D,其对角线上的N个元素即为相应的广义特征值
else    % 这段还是暂时不用,r使用默认值d
  opts.disp = 0; 
  [U,D]=eigs(Sb,Sw,r,'la',opts);
end


%线性bregman迭代进行稀疏处理
% V = P*U;
tq = size(U,2);
%初始化相关变量
V = zeros(d,tq); B = zeros(d,tq);                                                                                         
delta=.01; mu=.5;    % delta mu 作为参数 对比迭代得到的V和PU相乘的V
if nargin<6
    %epsilon=10^(-5);
    epsilon=50;
end
%线性迭代算法
k=1;
ttemp(1) = norm(P'*V-U);
while ttemp(k)>=epsilon %循环判断
    k=k+1;
    B = B - P*(P'*V-U);
    V = delta*shrink(B,mu);
    ttemp(k) = norm(P'*V-U);
end

Z=V'*XXX;
X_tst = V'*x_tst;
