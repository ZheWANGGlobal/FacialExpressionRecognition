function [mapping,XX_trn,XX_tst] = MFA(X_trn,Y_trn,X_tst,dims)
% MPA Perform Marginal Fisher Analysis
% Perform the Marginal Fisher Analysis on dataset X_trn to reduce it 
% dimensionality no_dims,The number fo neighbors that si used by MFA is
% specified by k=1;
% original author @Tomek 
% if ~exist('no_dims','var')
%     no_dims=2;
% end
X_trn = double(X_trn);
X_tst=double(X_tst);
F1=zeros(size(X_trn,1),size(X_trn,1));
for i=1:size(X_trn,1)
      for j=1:size(X_trn,1)
           dist(i,j)=norm(X_trn(i,:)-X_trn(j,:),2);
      end
end
[tmp,ind]=sort(dist,2);
% 构建邻接图F1
for i=1:size(X_trn,1)
    for j=(i+1):size(X_trn,1)
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
    for j=(i+1):size(X_trn,1)
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

Sw=X_trn'*(S1-F1)*X_trn;
Sb=X_trn'*(S2-F2)*X_trn;
Sw=Sw+eye(size(Sw,1))*1.e-8;
Sb=Sb+eye(size(Sw,1))*1.e-8;

[eigvectors,eigvalues]=eig(Sw,Sb);

% eigvalues(isnan(eigvalues))=0;

[eigvalues1,ind]=sort(diag(eigvalues),'ascend');

eigvalues=eigvalues1;
eigvectors=eigvectors(:,ind);

eigvectors=eigvectors(:,ind);
eigvectors=eigvectors(:,ind(1:dims));
mapping=eigvectors;
%mapping=uint8(mapping);
XX_trn=X_trn*mapping;
 XX_tst=X_tst*mapping;


