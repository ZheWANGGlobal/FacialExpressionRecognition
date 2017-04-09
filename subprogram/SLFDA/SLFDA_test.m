clear
% 表情识别
load Jaffe;
load JaffeThirtyTwo;
% clear Y1;
% Y=Y1;
% load JaffeThirtyTwo;

% %人脸识别
% load YaleBThirtyTwo;
% load YaleB_Y;


% 表情识别
% [V,Z]=SparseLocal_FDA(JaffeThirtyTwo,Y); % V是投影矩阵  Z是降维之后的矩阵

% % 人脸识别
% [V,Z]=SparseLocal_FDA(YaleBThirtyTwo,YaleB_Y);



%ZZ = imageResize2(Z);
% ZZ = Z';

N1=20;
%Z=double(Z)./255;

global p1 knn
 knn=1;
p1=2^-8;
C=100;
ker='linear';
ker='rbf';
% for loop=1:8
%  %[x_trn,y_trn,x_tst,y_tst,trainindex,testindex]=sample_random(ZZ,YaleB_Y,N1);
%  [x_trn,y_trn,x_tst,y_tst,trainindex,testindex]=sample_random(ZZ,Y,N1);
% %  [~,P]=pca(x_trn,size(x_trn,1));
% %  newx_trn=x_trn*P;
% %  newx_tst=x_tst*P;
% %   [out]=cknear(knn,newx_trn,y_trn,newx_tst); 
% %   mean(out==y_tst)
% 
%  %% KNN
%   [out]=cknear(knn,x_trn,y_trn,x_tst); 
%   Acc(loop,1)=mean(out==y_tst);
%   
% %   %% SVM
% %  [model,err,predictY,out]= SVC_lib_tt(x_trn,y_trn,ker,C,x_tst,y_tst);
% %    Acc(loop,2)=1-err;
% 
% %    %% Fisher discriminant analysis
% %    [W,bias,method]=fisher_discriminant(x_trn,y_trn);
% %     [out]=fisher_out(x_trn,y_trn,x_tst,'knn',W,knn);
% %       Acc(loop,3)=mean(out==y_tst);
% 
% end


 X = JaffeThirtyTwo;

indices=crossvalind('Kfold',Y,10);%进行随机分包
for k=1:10                   %交叉验证k=10，10个包轮流作为测试集   
   test = (indices == k);   %获得test集元素在数据集中对应的单元编号
   train = ~test;           %train集元素的编号为非test元素的编号
   x_trn=X(:,train);     %从数据集中划分出train样本的数据
%    y_trn=Y(train);%获得样本集的测试目标，在本例中是实际分类情况
   y_trn=Y(train);
   x_tst=X(:,test);%test样本集
%    y_tst=Y(test);
   y_tst=Y(test);
%  [eigenvectors_transMat,eigvalues,X_trn,X_tst]=sparse_DNE(x_trn,x_tst,y_trn);
 [V,X_trn,X_tst]=SparseLocal_FDA(x_trn,y_trn,x_tst);
 X_trn = real(X_trn);
 X_tst = real(X_tst);
   [out1]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,1)=mean(out1==y_tst);
%  [eigenvectorslast,eigvalues,X_trn,X_tst,d]=DNE(x_trn,x_tst,y_trn,1);
    [V,X_trn]=LFDA(x_trn,y_trn);
    X_tst=V'*x_tst;
  [out2]=cknear(knn,X_trn,y_trn,X_tst); 
  Acc(k,2)=mean(out2==y_tst);

 end
mean(Acc)