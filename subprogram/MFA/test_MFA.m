clear
% 表情识别
% load Jaffe;
% load Jaffe32_row;
% load YaleB32_row;
% load YaleB_Y;
% load AR32_row;
% load AR32_row_Y;
% load CK_Y;
% load CK64_row;
load CK32Row;
load CKROW_Y;
%Z=double(Z)./255;
N1=20;%训练样本数
global p1 knn
knn=1;
p1=2^-8;

% n折交叉验证
% [M,N]=size(X);%数据集为一个M*N的矩阵，其中每一行代表一个样本
 X = CK32Row;
 Y=CKROW_Y;
% X = AR32_row;
% X = CK64_row;

indices=crossvalind('Kfold',Y,8);%进行随机分包
for k=1:8                  %交叉验证k=10，10个包轮流作为测试集   
   test = (indices == k);   %获得test集元素在数据集中对应的单元编号
   train = ~test;           %train集元素的编号为非test元素的编号
   x_trn=X(train,:);     %从数据集中划分出train样本的数据
%    y_trn=Y(train);%获得样本集的测试目标，在本例中是实际分类情况
   y_trn=Y(train);
   x_tst=X(test,:);%test样本集
   y_tst=Y(test);
   
 [eigenvectors_transMat,X_trn,X_tst]=sparse_MFA(x_trn,y_trn,x_tst); 
   [out1]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,1)=mean(out1==y_tst);
  
 [mapping,X_trn,X_tst] = MFA(x_trn,y_trn,x_tst,186);
 [out2]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,2)=mean(out2==y_tst);

 end

mean(Acc)