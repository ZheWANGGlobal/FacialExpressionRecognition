function [out] = svc_lib_tt_ker_out(TestX,model)
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
    help svc_lib_tt_ker_out
  else
global p1   
   
        n=size(TestX,1);
% %        K=kernel(ker,TestX,X);
%        K1=[(1:n)' K/(2*C)];
        TestY=zeros(n,1);
%        [predictY,err,out] = svmpredict1(TestY,K1,model);  
        [predictY,err,out] = svmpredict1(TestY,TestX,model); 
       
  end
 
    
