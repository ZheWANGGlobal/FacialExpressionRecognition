function [Predict_Y,Y]=fisher_out(X_trn,Y_trn,X_tst,method,W,bias,ker)
%usage:[Predict_Y]=fisher_out(X_tst,W,bias,X_trn,ker)
%
%
if nargin<7 ker=[];end
if nargin<6 bias=1; end
if isempty(method); method='knn';end

if nargin>7
    help fisher_out
end
   if ~isempty(ker) 
        global p1
        X_tst=kernel(ker,X_tst,X_trn);   
        X_trn=kernel(ker,X_trn,X_trn);
   end
   Y=0;
  switch lower(method)
      case 'threshold'
        out=X_tst*W(:,1);
        C=unique([bias.class]);  
        if length(C)==2
            Y=(out-bias.value).*bias.sign
            Predict_Y=sign(Y);
        else
            for i=1:length(out)
                S=zeros(length(C));
                for j=1:length(bias)
                    k=bias(j).class;
                    f=sign((out(i)-bias(j).value)*bias(j).sign);                    
                    if f==1
                        S(k(1),k(2))=1;
                    else
                        S(k(2),k(1))=1;
                    end
                end               
                [s,f]=max(sum(S,2));
                Predict_Y(i,1)=f;
                
            end
        end
      case 'knn'  
          knn=bias;
          X_tst=X_tst*W;
          X_trn=X_trn*W;
          Predict_Y=cknear(knn,X_trn,Y_trn,X_tst); 
  end