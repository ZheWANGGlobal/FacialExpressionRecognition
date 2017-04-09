function [x_trn,y_trn,x_tst,y_tst,trainindex,testindex]=sample_random(X,Y,N1,N2)
% random samples under the condiditon of  training and test number
%
% N1 training number, N2 test number
%
%
 trainindex=[];
    testindex=[];
if nargin<4
    classnum=unique(Y);
    x_trn=[];y_trn=[];x_tst=[];y_tst=[];
   
    if N1>1
        for i=1:length(classnum)
            in=find(classnum(i)==Y);
            X1=X(in,:);
            index=randperm(length(in));
            N2=length(index)-N1;
            x_trn=[x_trn;X1(index(1:N1),:)];
            x_tst=[x_tst;X1(index(N1+1:end),:)];
            y_trn=[y_trn;classnum(i)*ones(N1,1)];
            y_tst=[y_tst;classnum(i)*ones(N2,1)];
     trainindex=[trainindex; in(index(1:N1))];
            testindex=[testindex ;in(index(N1+1:end))];
        end
    else
        n1=N1;n2=1-N1;
        for i=1:length(classnum)
            in=find(classnum(i)==Y);
            X1=X(in,:);
            index=randperm(length(in));
            N1=ceil(length(in)*n1);
            N2=length(in)-N1;
            x_trn=[x_trn;X1(index(1:N1),:)];
            x_tst=[x_tst;X1(index(N1+1:end),:)];
            y_trn=[y_trn;classnum(i)*ones(N1,1)];
            y_tst=[y_tst;classnum(i)*ones(N2,1)];
         trainindex=[trainindex; in(index(1:N1))];
            testindex=[testindex ;in(index(N1+1:end))];
        end
    end
    
else
    classnum=unique(Y);
    x_trn=[];y_trn=[];x_tst=[];y_tst=[];
    if N1>1
        for i=1:length(classnum)
            in=find(classnum(i)==Y);
            X1=X(in,:);
            index=randperm(length(in));
            x_trn=[x_trn;X1(index(1:N1),:)];
            x_tst=[x_tst;X1(index(N1+1:N1+N2),:)];
            y_trn=[y_trn;classnum(i)*ones(N1,1)];
            y_tst=[y_tst;classnum(i)*ones(N2,1)];
           trainindex=[trainindex; in(index(1:N1))];
            testindex=[testindex ;in(index(N1+1:N1+N2))];
        end
    else
        n1=N1;n2=N2;
        for i=1:length(classnum)
            in=find(classnum(i)==Y);
            X1=X(in,:);
            index=randperm(length(in));
            N1=ceil(length(in)*n1);
            if n1+n2==1
                N2=length(in)-N1;
            else
                N2=ceil(length(in)*n2);
            end
            x_trn=[x_trn;X1(index(1:N1),:)];
            x_tst=[x_tst;X1(index(N1+1:N1+N2),:)];
            y_trn=[y_trn;classnum(i)*ones(N1,1)];
            y_tst=[y_tst;classnum(i)*ones(N2,1)];
            trainindex=[trainindex; in(index(1:N1))];
            testindex=[testindex ;in(index(N1+1:N1+N2))];
        end
    end
end