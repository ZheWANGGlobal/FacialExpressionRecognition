function svcplot(X,Y,ker,alpha,bias,XX,W,SV,C,model)
%SVCPLOT Support Vector Machine Plotting routine
%
%  Usage: svcplot(X,Y,ker,alpha,bias,zoom,xaxis,yaxis,input)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - kernel function
%              alpha  - Lagrange Multipliers
%              bias   - Bias term
%              aspect - Aspect Ratio (default: 0 (fixed), 1 (variable))
%              mag    - display magnification
%              xaxis  - xaxis input (default: 1)
%              yaxis  - yaxis input (default: 2)
%              input  - vector of input values (default: zeros(no_of_inputs))
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk)

if (nargin < 5 | nargin > 10) % check correct number of arguments
    help svcplot
else

    epsilon = 1e-5;

    yaxis = 2;
    xaxis = 1;
    mag = 0.1;aspect = 0;
    if nargin<10 model=0;end
    if nargin<9 C=0;end
    if nargin<8 SV=X;end
    if nargin<7 W=[];end
    if (nargin < 6) XX=[];,input = zeros(1,size(X,2)); end

    % Scale the axes
    if isempty(XX)
        xmin = min(X(:,xaxis));, xmax = max(X(:,xaxis));
        ymin = min(X(:,yaxis));, ymax = max(X(:,yaxis));
    else
        xmin = min(XX(:,xaxis));, xmax = max(XX(:,xaxis));
        ymin = min(XX(:,yaxis));, ymax = max(XX(:,yaxis));
    end
    xa = (xmax - xmin);, ya = (ymax - ymin);
    if (~aspect)
        if (0.75*abs(xa) < abs(ya))
            offadd = 0.5*(ya*4/3 - xa);,
            xmin = xmin - offadd - mag*0.5*ya;, xmax = xmax + offadd + mag*0.5*ya;
            ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
        else
            offadd = 0.5*(xa*3/4 - ya);,
            xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
            ymin = ymin - offadd - mag*0.5*xa;, ymax = ymax + offadd + mag*0.5*xa;
        end
    else
        xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
        ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
    end

    set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);

    % Plot function value

    [x,y] = meshgrid(xmin:(xmax-xmin)/50:xmax,ymin:(ymax-ymin)/50:ymax);
    if C==0
        z = bias*ones(size(x));
        wh = waitbar(0,'Plotting...');
        for x1 = 1 : size(x,1)
            for y1 = 1 : size(x,2)
                input(xaxis) = x(x1,y1);, input(yaxis) = y(x1,y1);
                for i = 1 : size(SV,1)
                    if ~isempty(W)
                        if (abs(alpha(i)) > epsilon)
                            tempx1=kernel(ker,input,SV)*W;
                            tempx2=kernel(ker,SV(i,:),SV)*W;
                            z(x1,y1) = z(x1,y1) + Y(i)*alpha(i)*svkernel(ker,tempx1,tempx2);
                        end
                    else
                        if (abs(alpha(i)) > epsilon)
                            z(x1,y1) = z(x1,y1) + Y(i)*alpha(i)*svkernel(ker,input,SV(i,:));
                        end

                    end
                end
            end
            waitbar((x1)/size(x,1))
        end
        close(wh)
    else
        input=[x(:) y(:)];
        z =svc_lib_tt_out(input,model);
        z=reshape(z,size(x,1),size(x,2));
    end


    hold on
    for i = 1:size(Y)
        if (Y(i) == 1)
            plot(X(i,xaxis),X(i,yaxis),'rs','LineWidth',2,'MarkerSize',8) % Class A
        else
            plot(X(i,xaxis),X(i,yaxis),'bd','LineWidth',2,'MarkerSize',8) % Class B
        end
    end

    % Plot Boundary contour

    hold on
    contour(x,y,z,[0 0],'k','LineWidth',2)
    %     contour(x,y,z,[-1 -1],'w:','LineWidth',2)
    %     contour(x,y,z,[1 1],'k:','LineWidth',2)
    hold off

end
