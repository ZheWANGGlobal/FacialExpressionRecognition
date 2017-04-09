function [mapping,eigvalues,d] = MDNE_wei(X_trn,Y_trn,dim)
% MPA Perform Marginal Fisher Analysis
% Perform the Marginal Fisher Analysis on dataset X_trn to reduce it 
% dimensionality no_dims,The number fo neighbors that si used by MFA is
% specified by k=1;
% original author @Tomek 
% if ~exist('no_dims','var')
%     no_dims=2;
% end


F1=zeros(size(X_trn,1),size(X_trn,1));
for i=1:size(X_trn,1)
      for j=1:size(X_trn,1)
           dist(i,j)=norm(X_trn(i,:)-X_trn(j,:),2);
      end
end

% dist=L2_distance(X_trn',X_trn');
% [shu,index]=sort(dist,2);


[tmp,ind]=sort(dist,2);
% 构建邻接图F1
for i=1:size(X_trn,1)
    for j=2:size(X_trn,1)
        if Y_trn(i)==Y_trn(ind(i,j));
            F1(i,ind(i,j))=1;
            F1(ind(i,j),i)=1;
            break;
        else
            continue;
        end
    end
end
% 构建邻接图F2
F2=zeros(size(X_trn,1),size(X_trn,1));
for i=1:size(X_trn,1)
    for j=2:size(X_trn,1)
        if Y_trn(i)~=Y_trn(ind(i,j));
            F2(i,ind(i,j))=1;
            F2(ind(i,j),i)=1;
            break;
        else
            continue;
        end
    end
end
S1=diag(sum(F1));
S2=diag(sum(F2));

% % DD=S1-F1-S2+F2;
DD=S2-F2-S1+F1;
Matrix=X_trn'*DD*X_trn;
symMatrix=(Matrix+Matrix')./2;
symMatrix(isnan(symMatrix)) = 0;
[eigvectors,eigvalues]=eig(symMatrix+eye(size(symMatrix,1))*1.e-8);
[shu,order]=sort(diag(eigvalues),'descend');
eigvalues=shu;
eigvectors=eigvectors(:,order);
% % 选择第d个特征值，第d个特征值是接近于零的；
d=sum(eigvalues>0.000000001);
% if d==0
%     disp('这个数据集不用降维，因为降低纬度也不能使分辨率变高');
%     X_trn=x_trn;
%     X_tst=x_tst;
%     eigenvectorslast=[];
% else
%     disp('降到%d维',d);
%     order=order(1:dimension);
    eigenvectorslast=eigvectors(:,1:dim);
    % % % % eigenvectorslast也就是投影矩阵
    % % 投影
%     X_trn=x_trn*eigenvectorslast;
%     X_tst=x_tst*eigenvectorslast;

% Sw=X_trn'*(S1-F1)*X_trn;
% Sb=X_trn'*(S2-F2)*X_trn;
% 
% [eigvectors,eigvalues]=eig(Sw,Sb);
% 
% eigvalues(isnan(eigvalues))=0;
% 
% [eigvalues,ind]=sort(diag(eigvalues));
% 
% eigvectors=eigvectors(:,ind(1:no_dims));
mapping=eigenvectorslast;


