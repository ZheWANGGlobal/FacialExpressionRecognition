function [TestY,Neighbor_num,Neighbor,D]=nearest_neighbor(TrainX,TrainY,TestX,Knn,out)
%Nearest-neighbor algorithm
%
% usage: [TestY,In]=nearest_neighbor(TrainX,TrainY,TestX,Knn)
%       TrainX:    Training set X
%       TrainY:    Expected values of training set
%       TestX:     Test set
%       Knn:       the neighbor number
%       out:       the output number [1 1 0] [1 0 1] [1 1 1] [0 0 0]
%       TestY:     Output---expected values of TestX
%       Neighbor_num:  Output---the number of neighbor in each class
%       Neighbor:  Output---the serias of neighbors in TrainX
%
% Author: zhangli@mail.xidian.edu.cn

if nargin<3 & nargin>5
    help nearest_neighbor;
else
    if nargin<5 out=[1 1 0]; end
    if nargin<4 Knn=1; end
    maxy=max(TrainY);
    if maxy==1
        Yindex=[-1,1];
    else
        Yindex=[1:maxy];
    end
    m=size(TrainX,1);
    n=size(TestX,1);
    TestY=zeros(n,1);
    In=zeros(n,length(Yindex));
    Neighbor_num=zeros(n,length(Yindex));
    Neighbor=[];
    for j=1:n
        T=ones(m,1)*TestX(j,:);
        d=sqrt(sum(abs(T-TrainX).^2,2));
        [d1,index]=sort(d);
        if d1(1)==0
            if all(out==[1 1 1])
                Neighbor(j).index=index(2:Knn+1);
                temp=TrainY(index(2:Knn+1));
                Index=zeros(length(Yindex),1);
                for i=1:length(Yindex)
                    Index(i)=sum(temp==Yindex(i));
                end
                in=find(max(Index)==Index);
                TestY(j)=Yindex(in(1));
                Neighbor_num(j,:)=Index';
            elseif all(out==[1 1 0])
                Neighbor(j,:)=index(2:Knn+1);
                temp=TrainY(index(2:Knn+1));
                Index=zeros(length(Yindex),1);
                for i=1:length(Yindex)
                    Index(i)=sum(temp==Yindex(i));
                end
                in=find(max(Index)==Index);
                TestY(j)=Yindex(in(1));
                Neighbor_num(j,:)=Index';
            elseif all(out==[1 0 1])
                Neighbor(j).index=index(2:Knn+1);
                %  Neighbor_num(j,:)=[];
                Neighbor_num=[];
            elseif all(out==[0 0 0])
                TestY=[];
                 Neighbor_num=[];
                  Neighbor=[];
                  D(j)=d1(Knn+1);
            end
        else
            if all(out==[1 1 1])
                Neighbor(j).index=index(1:Knn);
                temp=TrainY(index(1:Knn));
                Index=zeros(length(Yindex),1);
                for i=1:length(Yindex)
                    Index(i)=sum(temp==Yindex(i));
                end
                in=find(max(Index)==Index);
                TestY(j)=Yindex(in(1));
                Neighbor_num(j,:)=Index';
            elseif all(out==[1 1 0])
                Neighbor(j,:)=index(1:Knn);
                temp=TrainY(index(1:Knn));
                Index=zeros(length(Yindex),1);
                for i=1:length(Yindex)
                    Index(i)=sum(temp==Yindex(i));
                end
                in=find(max(Index)==Index);
                TestY(j)=Yindex(in(1));
                Neighbor_num(j,:)=Index';
            elseif all(out==[1 0 1])
                Neighbor(j).index=index(1:Knn);
                %  Neighbor_num(j,:)=[];
                Neighbor_num=[];
            elseif all(out==[0 0 0])
                TestY=[];
                Neighbor_num=[];
                Neighbor=[];
                D(j)=d1(Knn);           
            end
        end
    end
end

