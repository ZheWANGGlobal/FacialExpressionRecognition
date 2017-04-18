clear
% 表情识别
load Jaffe;
load Jaffe32_row;
% load YaleB32_row;
% load YaleB_Y;
% load AR32_row;
% load AR32_row_Y;
% load CK_Y;
% load CK64_row;
% load CK32Row_power;
% load CKROW_Y;
%Z=double(Z)./255;
N1=20;%训练样本数
global p1 knn
knn=1;
p1=2^-8;

% n折交叉验证
% [M,N]=size(X);%数据集为一个M*N的矩阵，其中每一行代表一个样本
 X = Jaffe32_row;
 Y=Y;
% X = AR32_row;
% X = CK64_row;

indices=crossvalind('Kfold',Y,8);%进行随机分包
correct1 = cell(1,8);
correct2 = cell(1,8);
for k=1:8                  %交叉验证k=10，10个包轮流作为测试集   
   test = (indices == k);   %获得test集元素在数据集中对应的单元编号
   train = ~test;           %train集元素的编号为非test元素的编号
   x_trn=X(train,:);     %从数据集中划分出train样本的数据
%    y_trn=Y(train);%获得样本集的测试目标，在本例中是实际分类情况
   y_trn=Y(train);
   x_tst=X(test,:);%test样本集
   y_tst=Y(test);
   
    [eigvectorPCA,eigvaluePCA] = PCA2(double(x_trn),1003);
 x_trn_PCA = double(x_trn)*eigvectorPCA;
  x_tst_PCA = double(x_tst)*eigvectorPCA; 
  
 [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn_PCA,y_trn,x_tst_PCA); 
   [out1]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,1)=mean(out1==y_tst);
    
 [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn,y_trn,x_tst); 
   [out2]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,2)=mean(out2==y_tst);
  
 [mapping,X_trn,X_tst] = MFA(x_trn_PCA,y_trn,x_tst_PCA);
 [out3]=cknear(knn,X_trn,y_trn,X_tst); 
%  
%   correct1{k} = (out1==y_tst);
%  correct2{k} = (out2==y_tst);
 %correct(:,k)=(out2==y_tst);
 Acc(k,3)=mean(out3==y_tst);

 end

% Y=uint8(Y);
% classnum = unique(Y);
% for i = 1 : length(classnum)
%     index{i} = find(Y == i);
% end
% for i = 1:20
%     for j = 1 : length(classnum)
%         in = round(rand(1,4)*(length(index{j}) - 1)+1);
%         index_trn(j,:) = index{j}(in);
%     end
%     trn = zeros(213,1);
%     trn(index_trn) = 1;
%     trn = logical(trn);
%     tst = ~trn;
%     x_trn=X(trn,:);
%     y_trn=Y(trn);
%     x_tst=X(tst,:);
%     y_tst=Y(tst);
%     
%     [eigvectorPCA,eigvaluePCA] = PCA2(double(x_trn),1003);
%     x_trn_PCA = double(x_trn)*eigvectorPCA;
%     x_tst_PCA = double(x_tst)*eigvectorPCA; 
% 
% %     [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn_PCA,y_trn,x_tst_PCA); 
% %     [out1]=cknear(knn,X_trn,y_trn,X_tst); 
% %     Acc(i,1)=mean(out1==y_tst);
%     [mapping,X_trn,X_tst] = MFA(x_trn_PCA,y_trn,x_tst_PCA);
%     [out2]=cknear(knn,X_trn,y_trn,X_tst); 
%      Acc(i,2)=mean(out2==y_tst);
% end
% 



% % for i=1:20
% % %     index_all = cell(7,1); % 每行是一个类别的样本
% % %     for j=1:7
% % %          index = find(Y==j);
% % %          index = classuint8(index);
% % %          index_trn{j} = index(round(rand(1,4)*length(index)));
% % %          index_tst{j} = ~index_trn{j};      
% % %     end
% % 
% %     index1 = find(Y==1);
% %     index_trn1 = index1(round(rand(1,4)*length(index1)));
% %     index2 = find(Y==2);
% %     index_trn2 = index2(round(rand(1,4)*length(index2)));
% %     index3 = find(Y==3);
% %     index_trn3 = index3(round(rand(1,4)*length(index3)));
% %     index4 = find(Y==4);
% %     index_trn4 = index4(round(rand(1,4)*length(index4)));
% %     index5 = find(Y==5);
% %     index_trn5 = index5(round(rand(1,4)*length(index5)));
% %     index6 = find(Y==6);
% %     index_trn6 = index6(round(rand(1,4)*length(index6)));
% %     index7 = find(Y==7);
% %     index_trn7 = index7(round(rand(1,4)*length(index7)));
% %     trn = zeros(213,1);
% %     for k=1:4
% %        trn(index_trn1(k,1)) = 1;
% %        trn(index_trn2(k,1)) = 1;
% %        trn(index_trn3(k,1)) = 1;
% %        trn(index_trn4(k,1)) = 1;
% %        trn(index_trn5(k,1)) = 1;
% %        trn(index_trn6(k,1)) = 1;
% %        trn(index_trn7(k,1)) = 1;
% %     end
    
%      x_trn = X(index_trn,:);
%      y_trn=Y(index_trn);
%      x_tst=X(index_tst,:);
%      y_tst=Y(index_trn);
% 
%      [eigvectorPCA,eigvaluePCA] = PCA2(double(x_trn),1003);
%      x_trn_PCA = double(x_trn)*eigvectorPCA;
%      x_tst_PCA = double(x_tst)*eigvectorPCA; 
% 
%     [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn_PCA,y_trn,x_tst_PCA); 
%     [out1]=cknear(knn,X_trn,y_trn,X_tst); 
%     Acc(k,1)=mean(out1==y_tst);
% 
%     [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn,y_trn,x_tst); 
%     [out1]=cknear(knn,X_trn,y_trn,X_tst); 
%     Acc(k,1)=mean(out1==y_tst);
% 
%     [mapping,X_trn,X_tst] = MFA(x_trn_PCA,y_trn,x_tst_PCA);
%     [out2]=cknear(knn,X_trn,y_trn,X_tst); 
% 
%     Acc(k,2)=mean(out2==y_tst);
%    
    
% % end

























% mean(Acc)