clear;
numset=2.^[8]';
Cset=2.^[1:6]';
Cset=20;
pset=2.^[2]';
recrate=zeros(length(numset),length(Cset),length(pset),2);
for k1=1:length(numset)
    for k2=1:length(Cset)
        for k3=1:length(pset)
            for k4=1:10
                [k1,k2,k3]
                trnnumsam1=numset(k1,1);
                trnnumsam2=numset(k1,1);
                trnnumsam=trnnumsam1+trnnumsam2;
                factor=10;
                sigma=0.5;
                trnx1=randn(trnnumsam1,2);
                trnx2=randn(trnnumsam2,2)+2;
                trnx=[trnx1;trnx2];
                trny=[ones(trnnumsam1,1);-ones(trnnumsam2,1)];
                [noisetrnx,noisetrny,noisetrnnumsam]=noisingexamples(trnx,trny,factor,'gaussian',0.5);

                tstnumsam1=1000;
                tstnumsam2=1000;
                tstnumsam=tstnumsam1+tstnumsam2;
                tstx1=randn(tstnumsam1,2);
                tstx2=randn(tstnumsam2,2)+2;
                tstx=[tstx1;tstx2];
                tsty=[ones(tstnumsam1,1);-ones(tstnumsam2,1)];

                figure(1);clf;
                plot(trnx1(:,1),trnx1(:,2),'r.');
                hold on;
                plot(trnx2(:,1),trnx2(:,2),'r+');
                % for k=1:noisetrnnumsam
                %     if noisetrny(k,1)==1
                %         plot(noisetrnx(k,1),noisetrnx(k,2),'b.');
                %     elseif noisetrny(k,1)==-1
                %         plot(noisetrnx(k,1),noisetrnx(k,2),'b+');
                %     end
                % end
                ker='rbf';
                C=Cset(k2,1);
                global p1 p2 p3;
                p1=pset(k3,1);
                p2=1;
                p3=0;
                Tol=1e-8;
                ShrinkOn=0;
                ProbabilityOn=0;
                CrossValidationOn=0;
                Weight=[[1;-1],[1;1];];
                %model = libsvc(trnx,trny,ker,C,Tol,ShrinkOn, ProbabilityOn,CrossValidationOn,Weight);
                %figure(2);
                %libsvcplot(trnx,trny,ker,model.SVs,model.sv_coef,model.rho);

                Q=(trny*trny').*KGram(ker, trnx,trnx);
                model = libguest([[1:trnnumsam]',Q],trny,'precomputed',C,-ones(trnnumsam,1),0,Weight,Tol,ShrinkOn, ProbabilityOn,CrossValidationOn);
                % ysv = Q(model.SVs, model.SVs)*fabs(model.sv_coef);
                % ysv = zeros(totalSV,1);
                % for i=1:model.totalSV
                %     ysv =
                figure(2);
                libsvcplot(trnx,trny,ker,trnx(model.SVs,:),model.sv_coef,model.rho);

                [predict_label, accuracy, valorprob] = libsvcpredict(tstx, model, tsty, ProbabilityOn);
                recrate(k1,k2,k3,1)=recrate(k1,k2,k3,1)+accuracy(1,1);

                model1 = libsvc(noisetrnx,noisetrny,ker,C,Tol,ShrinkOn, ProbabilityOn,CrossValidationOn,Weight);
                % figure(2);
                % libsvcplot(trnx,trny,ker,model.SVs,model.sv_coef,model.rho);
                [predict_label, accuracy, valorprob] = libsvcpredict(tstx, model1, tsty, ProbabilityOn);
                recrate(k1,k2,k3,2)=recrate(k1,k2,k3,2)+accuracy(1,1);
            end
        end
    end
end
recrate=recrate/10;
figure(1);clf;
hold on;
for k1=1:length(numset)
    for k2=1:length(Cset)
        for k3=1:length(pset)
            A(k2,k3)=recrate(k1,k2,k3,1);
            B(k2,k3)=recrate(k1,k2,k3,2);
        end
    end
    mesh(log2(pset),log2(Cset),A);
    pause;
    mesh(log2(pset),log2(Cset),B);
    pause;
end
ok
% [nsv,alpha,bias]=svc(x,y,ker,C);
% figure(3);
% svcplot(x,y,ker,alpha,bias);
% output= svcoutput(x,y,x,ker,alpha,bias,1);