clear
x_trn=[rand(10,2);rand(10,2)+1];
y_trn=[ones(10,1);-ones(10,1)];
x_tst=[rand(10,2);rand(10,2)+1];
y_tst=[ones(10,1);-ones(10,1)];

Weight=[1 1;-1 1];
beq=0;
C=10;
ker='linear';
global p1
p1=1;
Y=diag(y_trn);
K=Y*kernel(ker,x_trn,x_trn)*Y;
K=[[1:length(y_trn)]' K];
ker='precomputed';
c=-ones(size(y_trn));
model=libguest(K,y_trn,ker,C,c,beq,Weight);
K1=kernel('linear',x_tst,x_trn);
K1=[[1:size(x_tst,1)]' K1];
 [predict_label, accuracy, valorprob] = libsvcpredict(K1, model, y_tst);
%  libsvcplot(trnx,trny,ker,trnx(model.SVs,:),model.sv_coef,model.rho);
% [YY]=svcoutput(x_trn,y_trn,'linear',);
ker='linear';
model1=libsvc(x_trn,y_trn,ker,C);
[predict_label, accuracy, valorprob] = libsvcpredict(x_tst, model1, y_tst);
