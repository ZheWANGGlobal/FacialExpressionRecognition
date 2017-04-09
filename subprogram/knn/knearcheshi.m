clc;
clear;
load iris_1.mat;
k=7;
testset=[randn(1000,2);randn(1000,2)+2];
sampleset=[randn(500,2);randn(100,2)+2;randn(100,2)+4];;
samplesign=[ones(500,1);2*ones(100,1);3*ones(100,1)];
% sampleset=[1 1;2 2;3 3; 4 4;];;
% samplesign=[ones(2,1);2*ones(1,1);3*ones(1,1)];
testsign=samplesign;
tic
% [judge,r,gailv]=cknear(k,sampleset,samplesign,testset); %%函数输出可以取前两个或者第一个
 [judge,r,gailv]=cknear(k,sampleset,samplesign,sampleset); %%函数输出可以取前两个或者第一个
toc
% tic
% judge1=knear(k,sampleset,samplesign,testset);
% toc

tic
% [judge1]=nearest_neighbor(sampleset,samplesign,testset,k);
[judge1,r1,g1]=nearest_neighbor(sampleset,samplesign,sampleset,k);
toc
diff=sum(judge1~=judge)
% r
% gailv

