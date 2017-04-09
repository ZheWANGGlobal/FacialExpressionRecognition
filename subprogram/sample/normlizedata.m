function [X,MaxX,MinX]=normlizedata(X,method,MaxX,MinX)
if nargin<3 MaxX=[];MinX=[];end
if nargin<2 method='0-1';end
switch lower(method)
    case '0-1'
        if isempty(MinX)
            MaxX=max(X);MinX=min(X);
        end
        for i=1:size(X,2)
            X(:,i)=(X(:,i)-MinX(i))./(MaxX(i)-MinX(i)+1.e-8);
        end
    case '1-norm'
        for i=1:size(X,2)
            X(:,i)=X(:,i)/norm(X(:,i));
        end
    case '-1+1'
        if isempty(MinX)
            MaxX=max(X);MinX=min(X);
        end
        for i=1:size(X,2)
            X(:,i)=X(:,i)./max(abs([MaxX(i),MinX(i)]));
        end
    case 'zcore'
        if isempty(MinX)
            MinX=mean(X);
            for i=1:size(X,2)
                MaxX(i)=sqrt(mean((X(:,i)-MinX(i)).^2));
                X(:,i)=(X(:,i)-MinX(i))./(MaxX(i)+1.e-8);
            end
        else
            for i=1:size(X,2)
                X(:,i)=(X(:,i)-MinX(i))./(MaxX(i)+1.e-8);
            end
        end
        
end