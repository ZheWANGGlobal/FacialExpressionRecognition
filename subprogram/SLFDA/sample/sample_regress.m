function [Trx,Try,Tex,Tey,index]=sample_regress(x,y,N,index,t,Num_method)
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


if nargin< 2 | nargin>6 help sample_crossover;end
if nargin<6 Num_method=1;end
if nargin<5 t=1;end
if nargin<4 index=[];end
if nargin<3 N=[10 1]; end
rand('state',sum(100*clock));
Lx=size(x,1);
fold=ceil(Lx/N(1));
if Num_method==1
    if isempty(index)
        in=randperm(Lx);
        for i=1:N(1)-1
        index(i).fold=in((i-1)*fold+1:i*fold);
        index(i).num=[fold];
        end        
        index(i+1).fold=in((i-1)*fold+1:end);
        index(i+1).num=length(in((i-1)*fold+1:end));        
    end
    xxindex=[];
    xxindex=index(t).fold;
    xindex=[1:Lx]';
    xindex(xxindex)=[];
    Tex=x(xxindex,:);
    Tey=y(xxindex');
    Trx=x(xindex,:);
    Try=y(xindex);        
elseif Num_method==2
    Try=[];Tey=[];
    Trx=[];Tex=[];
    for i=1:length(oldy)
        in=find(y==oldy(i));
        tempx=x(in,:);
        tempy=y(in,:);
        index=randperm(length(tempy));
        in=index(1:ceil(length(tempy)*N(2)/N(1)));
        Tex=[Tex;tempx(in,:)];
        Tey=[Tey;tempy(in,:)];
        tempx(in,:)=[];
        tempy(in,:)=[];
        Trx=[Trx;tempx];
        Try=[Try;tempy];        
    end
    index=[];
end
% if ismember(-1,oldy)
%     indexi=find(Tey==2);
%     Tey(indexi,:)=-1;
%     indexi=find(Try==2);
%     Try(indexi,:)=-1;
%     
% end


