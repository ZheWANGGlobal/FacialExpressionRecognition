function [model,err,predictY] = svc_lib_tt1(X,Y,ker,C,TestX,TestY)
%%this is direct to get the results
%kernel input
%For SVM using Libsvm to triaing and test
%  Usage: [model,err,predictY] = svc_lib_tt(X,Y,ker,C,TestX,TestY)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - kernel function
%              C      - upper bound (non-separable case)
%            TestX  TestY : test data
%             
%            model: out parameters including alpha and bias
%            err  :the error of Test data
%          predictY: the output of TestX
%  Author: Li ZHANG (zhangli@mail.xidian.edu.cn)

  if (nargin <2 | nargin>6) % check correct number of arguments
    help svc
  else
global p1
    
    n = size(X,1);
    if nargin<6 TestX=[];TestY=[];end
    if nargin<4 C=[1 1];end
    if nargin<3 ker='linear';end
    %if length(C)==1 C=C;end

    % tolerance for Support Vector Detection
    epsilon = 1.0e-8; %svtol(C);
    switch lower(ker)
        case 'linear'
            kernum=0;
            string=['-t 4 -c ', num2str(C)];
        case 'poly'
            kernum=1;
            string=['-t 4 -c ', num2str(C)];
        case 'rbf'
            kernum=2;
            string=['-t 4 -c ', num2str(C)];
    end
    K=kernel(ker,X,X);
    save svckerfun K
    K2=[[1:n]' K];
    model = svmtrain(Y,K2,string);
    % Implicit bias, b0
   if ~isempty(TestY)
       K=kernel(ker,TestX,X);
       save svckerfunt K
       K2=[[1:size(TestX,1)]' K];
         [predictY,err] = svmpredict(TestY,K2,model); 
         err=1-err(1)/100;
     else
         err=-1;predictY=0;
   end   
  end
 
    
