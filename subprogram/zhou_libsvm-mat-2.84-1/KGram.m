function G=KGram(ker,x,y)
%Comper Kernel gram matrix
%usage:
%          G=KGram(ker,x,y)

global p1 p2;
[NumSam1,Dim]=size(x);
[NumSam2,Dim]=size(y);
G=zeros(NumSam1,NumSam2);
switch lower(ker)
      case 'linear'
         G = x*y';
      case 'poly'
         G = (x*y').^p1;      
      case 'rbf'
            for k=1:Dim
                X=x(:,k)*ones(1,NumSam2);
                Y=ones(NumSam1,1)*y(:,k)';
                G=G-(X-Y).*(X-Y);
            end
            %temp=2*p1*p1;
            G=exp(p1*G);        
      case 'sigmoid'
         %k = tanh(p1*u*v'/length(u) + p2);
          G = tanh(p1*u*v' + p2);      
        otherwise
            G = u*v';
end


 
