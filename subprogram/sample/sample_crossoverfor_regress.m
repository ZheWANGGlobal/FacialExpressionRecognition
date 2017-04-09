function [Trx,Try,Tex,Tey,index]=sample_crossoverfor_regress(x,y,N,index,t)
% to get training and test samples for crossover method
% usage:    [Trx,Try,Tex,Tey]=sample_crossover(x,y,N,index,t,Num_method)
%          x:    --  the totall samples
%          y:    --  the output of x
%          N:    --  the fold of crossover. 1x2.[N1 N2]
%                    N1---fold of all samples,
%                    N2---fold of test samples
%      index:    --  the random series
%          t:    --  the times of crossover.
%  Num_method:   --  1 : crossover; 2: random select samples
%        Trx:    --  the training samples
%        Try:    --  the output of training samples
%        Tex:    --  the test samples
%        Tey:    --  the output of test samples
%
%Author : Zhang Li (zhangli_jasmine@yahoo.com.cn)


if nargin< 2 | nargin>5 help sample_crossover;end
% if nargin<6 Num_method=1;end
if nargin<5 t=1;end
if nargin<4 index=[];end
if nargin<3 N=[10 1]; end
rand('state',sum(100*clock));
Lx=size(x,1);
M=ceil(Lx/N(1)); % the number of test samples

if isempty(index)    
    in2=randperm(Lx);
    for i=1:N-1
       index(i).fold=in2((i-1)*M+1:i*M);
    end
    i=i+1;
   index(i).fold=in2((i-1)*M+1:end);
end
xxindex=index(t).fold;

xindex=[1:Lx]';
xindex(xxindex)=[];
Tex=x(xxindex,:);
Tey=y(xxindex');
Trx=x(xindex,:);
Try=y(xindex);


