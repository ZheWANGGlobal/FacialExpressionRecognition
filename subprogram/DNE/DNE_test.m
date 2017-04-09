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

%Z=double(Z)./255;
N1=20;%训练样本数
global p1 knn
knn=1;
p1=2^-8;


% %随机选取140张作为训练样本，73张作为测试集合 
% for loop=1:8
%  [x_trn,y_trn,x_tst,y_tst,trainindex,testindex]=sample_random(Jaffe16,Y,N1);
% [eigenvectorslast,eigvalues,X_trn,X_tst,d]=DNE(x_trn,x_tst,y_trn,1);
% %   [eigenvectors_transMat,eigvalues,X_trn,X_tst]=sparse_DNE(x_trn,x_tst,y_trn);
% 
% 
%  %% KNN
%   [out]=cknear(knn,X_trn,y_trn,X_tst); 
% %   [x_trn,y_trn,x_tst,y_tst,trainindex,testindex]=sample_random(Jaffe16,Y,N1);
% %   [out]=cknear(knn,x_trn,y_trn,x_tst); 
%   Acc(loop,1)=mean(out==y_tst);
% 
% end


% n折交叉验证
% [M,N]=size(X);%数据集为一个M*N的矩阵，其中每一行代表一个样本
 X = Jaffe32_row;
% X = AR32_row;
% X = CK64_row;

indices=crossvalind('Kfold',Y,8);%进行随机分包
for k=1:8                  %交叉验证k=10，10个包轮流作为测试集   
   test = (indices == k);   %获得test集元素在数据集中对应的单元编号
% test = (indices==1);
   train = ~test;           %train集元素的编号为非test元素的编号
   x_trn=X(train,:);     %从数据集中划分出train样本的数据
%    y_trn=Y(train);%获得样本集的测试目标，在本例中是实际分类情况
   y_trn=Y(train);
   x_tst=X(test,:);%test样本集
%    y_tst=Y(test);
   y_tst=Y(test);
%  [eigenvectors_transMat,eigvalues,X_trn,X_tst]=sparse_DNE(x_trn,x_tst,y_trn);
%    [out1]=cknear(knn,X_trn,y_trn,X_tst); 
% %    Acc(1,1)=mean(out1==y_tst);
%   Acc(k,1)=mean(out1==y_tst);
%   
% %   [V,eigvalues,X_trn,X_tst]=sparse_DNE_kickingBreagmanIteration(x_trn,x_tst,y_trn);
% %     [out2]=cknear(knn,X_trn,y_trn,X_tst); 
% %   Acc(k,2)=mean(out2==y_tst);
% 
%  [eigenvectorslast,eigvalues,X_trn,X_tst,d]=DNE(x_trn,x_tst,y_trn,1);
%   [out2]=cknear(knn,X_trn,y_trn,X_tst); 
% %    Acc(1,2)=mean(out2==y_tst);
%   Acc(k,2)=mean(out2==y_tst);
 [eigenvectorslast,eigvalues,X_trn,X_tst,d]=Locality_DNE(x_trn,x_tst,y_trn,20,1,23);
 [out3]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,3)=mean(out3==y_tst);
 [eigenvectorslast,eigvalues,X_trn,X_tst,d]=SparseLocality_DNE(x_trn,x_tst,y_trn,20,1,23);
 [out4]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,4)=mean(out4==y_tst);
 
%    %% KNN
%   [out]=cknear(knn,x_trn,y_trn,x_tst); 
%   Acc(k,1)=mean(out==y_tst);
 end
%上述结果为输出算法MLKNN的几个验证指标及最后一轮验证的输出和结果矩阵，每个指标都是一个k元素的行向量
mean(Acc)