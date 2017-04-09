function [W,bias,remethod]=fisher_discriminant(X,Y,method,methodout,ker)
%Fisher discriminant for classifcation problem
%[W,bias]=fisher_discriminant(X,Y,method,methodout,ker)
%

if nargin<2 | nargin>5 
    help fisher_discriminant;
else
    if nargin<5 ker=[];end
    if nargin<4  methodout='knn'; end
    if nargin<3 method='perturb'; end
if isempty(methodout) methodout='knn'; end
if isempty(method) method='perturb'; end
    if ~isempty(ker)  
         X=kernel(ker,X,X);
    end
    classnum=unique(Y);
    L=size(X,1);
    n=size(X,2);C=length(classnum);
    Hb=zeros(n,C);
    Hw=[];Ht=zeros(n,L);
    Sw=0;St=0;Sb=0;
    m=mean(X);N=0;   
    for i=1:C
        index1=find(Y==classnum(i));  
        Li=length(index1);
        tempx=X(index1,:);
        m1=mean(tempx); 
        Hb(:,i)=sqrt(Li)*(m1-m)';
        Hw=[Hw [(tempx-ones(Li,1)*m1)']];  
        N(i)=Li;
        %Sw=Sw+cov(X(index1,:))*(length(index1)-1);        
    end
    Ht=(X-ones(L,1)*m)';
    if C==2
        Sb=(Hb*Hb').*(L/prod(N));
    else
        Sb=Hb*Hb';
    end
    Sw=Hw*Hw';
    St=Ht*Ht';
    if rank(Sw)<size(Sw,1)
        remethod='same';
        switch lower(method)
            case 'perturb'
                Sw=Sw+1e-8.*eye(size(Sw));
                W=findW(Sw,Sb); 
                
            case 'pca_null' 
                W=findW_pca_null(St,Sw,Sb);                     
                
            case 'lda_qr'
                W=findW_LDA_QR(Hb,Sw,Sb);                     
               
            case 'lda_fkt'
                W=findW_LDA_fkt(Hb,Ht);   
            case 'fisherface'
                W=findW_Fisherface(St,Sb,Sw);  
            case 'lda_gsvd'  
                %W=findW_lda_gsvd(Hb,Hw); 
               [U,V,W,C1,S]=gsvd(Hb',Hw');
        end
    else
        W=findW(Sw,Sb);
        remethod='none';
    end
    switch lower(methodout)
        case 'knn'
            bias=0;
            if ~strcmp(method,'lda_gsvd')
                if size(W,2)>=C-1
                    W=W(:,1:C-1);               
                end
%             else
%                 W=W(:,end-C+1:end);
            end
        case 'threshold'
            %W=W(:,1);
            Xf=X*W(:,1);
            bias=findbias(Xf,Y,classnum);  
            W=W(:,1:C-1);
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W=findW(Sw,Sb);
    A=inv(Sw)*Sb;
    [U,D]=eig(A);D=diag(D);
    in=find(real(D)>1.e-8);
    D=D(in);
    U=U(:,in);
    [D,in]=sort(D);
    in=flipud(in);
    W=U(:,in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [W,U]=findW_pca_null(St,Sw,Sb);
   [U,D]=eig(St);
    D=diag(D);
    in=find(D>1.e-8);
    U=U(:,in);
    Sw1=U'*Sw*U;
    Sb1=U'*Sb*U;
    [Uw,Dw]=eig(Sw1);Dw=diag(Dw);
    in=find(Dw<=1.e-8);
    if ~isempty(in)
        Uw=Uw(:,in);    
        Sb2=Uw'*Sb1*Uw;
        if length(Sb2)>1
            [Ub,Db]=eig(Sb2);
            Db=diag(Db);
            in=find((Db)>1.e-8);
           if ~isempty(in)
               Ub=Ub(:,in);
               Db=Db(in);
           end
            [Db,in]=sort(Db);
             in=flipud(in);
            Ub=Ub(:,in);
            W=U*Uw*Ub;
        else
            W=U*Uw;
        end
    else
        A=inv(Sw1)*Sb1;
        [U1,D1]=eig(A);
        D1=diag(D1);
        in=find((D1)>1.e-8);    
        U1=U1(:,in);
        D1=D1(in);[D1,in]=sort(D1);
        W=U*U1(:,in);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% function W=findW_LDA_QR(Hb,Sw,Sb);    
%     [Q,R]=qr(Hb,0);
%     r=rank(Hb); 
%     R=R(1:r,:);Q=Q(:,1:r);
%     Sb1=Q'*Sb*Q;
%     Sw1=Q'*Sw*Q;
%     A=inv(Sb1)*Sw1;;
%     [U,D]=eig(A);
%     D=diag(D);
%     in=find((D)>1.e-8);
%     U=U(:,in);
%     D=D(in);[D,in]=sort(D);
%     W=Q*U(:,in);
function W=findW_LDA_QR(Hb,Sw,Sb);    
    [Q,R]=qr(Hb);
    r=rank(Hb); 
    R=R(1:r,:);Q=Q(:,1:r);
    Sb1=Q'*Sb*Q;
    Sw1=Q'*Sw*Q;
    A=inv(Sb1)*Sw1;;
    [U,D]=eig(A);
    D=diag(D);
    %in=find((D)>1.e-8);
    [D,in]=sort(D);
    U=U(:,in);
    %D=D(in);[D,in]=sort(D);
    %W=Q*U(:,in);
    W=Q*U;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W=findW_LDA_fkt(Hb,Ht)
[Q,R]=qr(Ht,0);
r=rank(Ht); 
R=R(1:r,:);Q=Q(:,1:r);
St1=R*R';
Z=Q'*Hb;
Sb1=Z*Z';
A=inv(St1)*Sb1;
%A=A+eye(size(A))*1.e-8;
%[P,D]=eig(A);
[P,D,S]=svd(A);
D=diag(D);
in=find(D>1.e-8);
D=D(in);
P=P(:,in);
[D,in]=sort(D);
in=flipud(in);

W=Q*P(:,in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W=findW_Fisherface(St,Sb,Sw);
rw=rank(Sw);
[U,D]=eig(St);
D=diag(D);
[D,in]=sort(D);
D=flipud(D);
in=flipud(in);
U=U(:,in);
U=U(:,1:rw);
A=inv(U'*Sw*U)*(U'*Sb*U);
[U1,D1]=eig(A);
D1=diag(D1);
[D1,in]=sort(D1);
in=flipud(in);
W=U*U1(:,in);

function W=findW_lda_gsvd(Hb,Hw);
C=size(Hb,2);
N=size(Hb,1);
H=[Hb'; Hw'];
[P,R,Q]=svd(H);
R=diag(R);
in=find(R>1.e-8);
R=diag(R(in));
t=rank(H);
[U,S,W]=svd(P(1:C,1:t));
%T=Q*[inv(R)*W zeros(t,N-t);zeros(N-t,t) eye(N-t)];
T=Q*[inv(R)*W;zeros(N-t,t)];
W=T;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function bias=findbias(Xf,Y,classnum)
    k=1;
    C=length(classnum);
    for i=1:C
        indexi=find(Y==classnum(i));
        for j=i+1:C
            indexj=find(Y==classnum(j));
            temp=[Xf(indexi);Xf(indexj)];
            bias(k).class=[classnum(i);classnum(j)];
            if C==2
                tempy=[-ones(length(indexi),1);ones(length(indexj),1)];
            else
                tempy=[ones(length(indexi),1);-ones(length(indexj),1)];
            end            
            b=mean(temp);
            bias(k).value=b;
            E=find(sign((temp-b)).*tempy==1);
            if length(E)./length(tempy)<0.2
                bias(k).sign=-1;
            else
                bias(k).sign=1;
            end 
            k=k+1;
        end           
    end