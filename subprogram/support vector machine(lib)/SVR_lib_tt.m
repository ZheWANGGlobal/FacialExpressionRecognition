function [model,err,predictY,out] = svr_lib_tt(X,Y,ker,C,TestX,TestY)
%%this is direct to get the results
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
    help svr
  else
global p1
    
    n = size(X,1);
    if nargin<6 TestX=[];TestY=[];end
    if nargin<4 C=[1 1];end
    if nargin<3 ker='linear';end
    
    % tolerance for Support Vector Detection
    epsilon = 1.0e-8; %svtol(C);
    switch lower(ker)
        case 'linear'
            kernum=0;
            string=['-t ',num2str(kernum'),' -c ', num2str(C)];
        case 'poly'
            kernum=1;
            string=['-t ',num2str(kernum'),' -c ', num2str(C),'-d ', num2str(p1)];
        case 'rbf'
            kernum=2;
            string=['-t ',num2str(kernum'),' -c ', num2str(C),' -g ',num2str(p1)];
    end
    Tol=1.e-5;ShrinkOn=0;ProbabilityOn=0;
    string=[string, ' -e ', num2str(Tol),' -h ', num2str(ShrinkOn),' -b ', num2str(ProbabilityOn)];
    sring=[string,' -m ', num2str(min(4*8*n*n/1e6,200))];

    model = svmtrain(Y,X,string);
    % Implicit bias, b0
   if ~isempty(TestY)         
         [predictY,err,out] = svmpredict(TestY,TestX,model); 
         err=1-err(1)/100;
     else
         err=-1;predictY=0;
   end   
    
  end
 
    
