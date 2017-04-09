function [Trx,Try,Tex,Tey,index]=sample_crossover(x,y,N,index,t,Num_method)
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
M=ceil(Lx/N(1)); % the number of test samples
oldy=unique(y);
% if ismember(-1,oldy)
%     indexi=find(y==-1);
%     y(indexi,:)=2;  
% end

if Num_method==1
%     if isempty(index)
%         index=randperm(Lx);    
%     end
%     xxindex=[];
%     if t<N(1)
%         xxindex=index((t-1)*M+1:t*M);
%     else
%         xxindex=index((t-1)*M+1:end);
%     end
%     xindex=[1:Lx]';
%     xindex(xxindex)=[];
%     Tex=x(xxindex,:);
%     Tey=y(xxindex');
%     Trx=x(xindex,:);
%     Try=y(xindex); 
    if isempty(index)
        for i=1:length(oldy)
            in1=find(oldy(i)==y);
            in2=randperm(length(in1));           
            index(i).fold=in1(in2);
            c1=floor(length(in1)/N(1));
            c2=ceil(length(in1)/N(1));
            if c1~=c2
                n2=(length(in1)-N(1)*c1)/(c2-c1);
                n1=N(1)-n2;
            else
                n2=N(1);n1=0;
            end
            index(i).num=[ones(n2,1)*c2;ones(n1,1)*c1];
        end        
    end
    xxindex=[];
    if t<N(1)
         for i=1:length(oldy)
             M1=sum(index(i).num(1:t-1));
             M2=sum(index(i).num(1:t));
             xxindex=[xxindex;index(i).fold(M1+1:M2)];                 
        end
    else
        for i=1:length(oldy)
             M1=sum(index(i).num(1:t-1));
             %M2=sum(index(i).num(1:t));
             xxindex=[xxindex;index(i).fold(M1+1:end)];                 
        end
    end
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


