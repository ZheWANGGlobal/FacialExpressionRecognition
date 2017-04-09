function [V,eigvalues,X_trn,X_tst]=sparse_DNE_kickingBreagmanIteration(x_trn,x_tst,y_trn,Knn)
% Inputs:
% x_trn   -Train samples one row present a samples
% x_tst   -Test samples
% Outputs
% eigenvectors   -a transform matrix
% X_trn      - new train samples
% X_tst      - new test samples

% global Knn
if nargin<4 Knn=1;end
% % % % DNE方法**********************DNE方法
x_trn = double(x_trn);
x_tst = double(x_tst);
for i=1:size(x_trn,1)
    for j=1:size(x_trn,1)
        dist(i,j)=norm(x_trn(i,:)-x_trn(j,:),2);
    end
end
% dist=L2_distance(x_trn',x_trn');
[~,index]=sort(dist,2);
F=zeros(size(x_trn,1),size(x_trn,1));   % F矩阵即邻接矩阵W
for i=1:size(x_trn,1)
    temp=index(i,2:Knn+1);
    in1=find(y_trn(temp)==y_trn(i));
    in2=find(y_trn(temp)~=y_trn(i));
    F(i,temp(in1))=1;
    F(temp(in1),i)=1;       
     F(i,temp(in2))=-1;
    F(temp(in2),i)=-1;  
end

S=diag(sum(F));   % S即为Dlt

Llt = (S-F);
[Qlt,Alpha]=eig(Llt);
Hlt = x_trn'*Qlt*abs(Alpha^(1/2));
[PP,aaa,~]=svd(Hlt); 
index=find(diag(aaa)>1.e-5);
PP=PP(:,index);
symMatrix=(x_trn*PP)'*(S-F)*(x_trn*PP);   %symMatrix即为Slt
symMatrix=(symMatrix+symMatrix')./2;
[eigvectors,eigvalues ]=eig(symMatrix+eye(size(symMatrix,1))*1.e-8); % 计算特征向量和特征值

[sort_eigval,sort_eigval_index]=sort(diag(eigvalues));
sort_eigval_index=find(sort_eigval<0);

eigvalues=sort_eigval(sort_eigval_index);
U=eigvectors(:,sort_eigval_index);

  


% U = PP'*U*PP;
% [U,D]=eig(U); 

% %线性bregman迭代进行稀疏处理
% tq = size(U,2);
% %初始化相关变量
% [n,d]=size(x_trn);
% V = zeros(d,tq); B = zeros(d,tq);    
% delta=.01; mu=0.5;    % delta mu 作为参数 对比迭代得到的V和PU相乘的V
% if nargin<5
%     %epsilon=10^(-5);
%     epsilon=0.1;
% end
% %线性迭代算法
% k=1;
% ttemp(1) = norm(PP'*V-U);
% while ttemp(k)>=epsilon %循环判断
%     k=k+1;
%     B = B - PP*(PP'*V-U);
%     V = delta*shrink(B,mu);
%     ttemp(k) = norm(PP'*V-U);    
% %     norm(B,'inf')
% end

n=size(f,1);
m=size(f,2);
n1=n-1; 
m1=m-1;
u=f; 
dx =zeros(n,m); dy=zeros(n,m); bx=zeros(n,m); by=zeros(n,m); 
k=0;
nn(1) = norm(u,2); p(1) = norm(f-X,2)/norm(X,2);
while nn(k+1) >Tol
k=k+1;
u1 = u ;
%Calculate u.
for i=2:n1
for j=2:m1
u(i,j)= g(u,dx,dy, bx, by,f, lambda, mu, i,j);
end
end
%Compute the ds
for i=2:n1
for j=1:m
dx(i,j) = shrink((u(i+1,j)- u(i-1,j))/2+bx(i,j),1/lambda);
end
end
for j=1:m
dx(1,j) = shrink((u(1+1,j)- u(1,j))+bx(1,j),1/lambda);
end
for j=1:m
dx(n,j) = shrink((u(n,j)- u(n-1,j))+bx(n,j),1/lambda);
end
for j=2:m1
for i=1:n
dy(i,j) = shrink((u(i,j+1) - u(i,j-1))/2 +by(i,j),1/lambda);
end
end
for i=1:n
dy(i,1) = shrink((u(i,2) - u(i,1)) +by(i,1),1/lambda);
end
for i=1:n
45
dy(i,m) = shrink((u(i,m) - u(i,m-1)) +by(i,m),1/lambda);
end
%Calculate the b’s
for i=2:n1
for j=1:m
bx(i,j) = bx(i,j) + (u(i+1,j)-u(i-1,j))/2 - dx(i,j) ;
end
end
for j=1:m
bx(1,j) = bx(1,j) + (u(1+1,j)-u(1,j)) - dx(1,j) ;
end
for j=1:m
bx(n,j) = bx(n,j) + (u(n,j)-u(n-1,j)) - dx(n,j) ;
end
for i=1:n
for j=2:m1
by(i,j) = by(i,j) + (u(i,j+1)-u(i,j-1))/2 - dy(i,j) ;
end
end
for i=1:n
by(i,1) = by(i,1) + (u(i,1+1)-u(i,1)) - dy(i,1) ;
end
for i=1:n
by(i,m) = by(i,m) + (u(i,m)-u(i,m-1)) - dy(i,m) ;
end
nn(k+1) = norm(u-u1,2)/norm(u,2);
nn(k); nn(k+1);
46
p(k+1)= norm(u-X,2)/norm(X,2);
end


X_trn=x_trn*V;
X_tst=x_tst*V;
% % % 投影
% X_trn=x_trn*eigvectors;
% X_tst=x_tst*eigvectors;
% end
end
% % % % DNE方法**********************DNE方法

        

