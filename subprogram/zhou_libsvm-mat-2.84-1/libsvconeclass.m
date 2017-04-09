function model=libsvconeclass(x,y,ker,C,Tol)
%Solve support vector machine for one classification (novelty detection) by using lib svm software
%usage:
%model=libsvc(x,y,ker,C,e,Tol,ShrinkOn,ProbabilityOn,CrossValidationOn,Weight);
%model     --      A struct of learning results
%x             --      Training examples
%y             --      label for the training examples
%ker          --      kernel type
%Tol          --      Terminating tolearnce

%LibSVM training options:
% svm_type : set type of SVM (default 0)
%                 0 -- C-SVC
%                 1 -- nu-SVC
%                 2 -- one-class SVM
%                 3 -- epsilon-SVR
%                 4 -- nu-SVR
%             -t kernel_type : set type of kernel function (default 2)
%                 0 -- linear: u'*v
%                 1 -- polynomial: (gamma*u'*v + coef0)^degree
%                 2 -- radial basis function: exp(-gamma*|u-v|^2)
%                 3 -- sigmoid: tanh(gamma*u'*v + coef0)
%             -d degree : set degree in kernel function (default 3)
%             -g gamma : set gamma in kernel function (default 1/k)
%             -r coef0 : set coef0 in kernel function (default 0)
%             -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
%             -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
%             -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
%             -m cachesize : set cache memory size in MB (default 100)
%             -e epsilon : set tolerance of termination criterion (default 0.001)
%             -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
%             -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
%             -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
%
%             The k in the -g option means the number of attributes in the input data.
%
%             option -v randomly splits the data into n parts and calculates cross
%             validation accuracy/mean squared error on them.
if nargin<4 | nargin>5
    help libsvconeclass
else    
    if nargin<5, Tol=1e-5;,end
   
    global p1 p2;
    [numsam,dim]=size(x);
    LibSVMTrainOptions=[];
    LibSVMTrainOptions=[LibSVMTrainOptions,' -s 2 '];
    switch lower(ker)
        case 'linear'
            LibSVMTrainOptions=[LibSVMTrainOptions,' -t 0 '];
        case 'poly'
            LibSVMTrainOptions=[LibSVMTrainOptions,' -t 1 -d ',num2str(p1),' ',' -r ',num2str(p2),' '];
        case 'rbf'
            LibSVMTrainOptions=[LibSVMTrainOptions,' -t 2 -g ',num2str(p1),' '];
        case 'sigmoid'
            LibSVMTrainOptions=[LibSVMTrainOptions,' -t 3 -g ',num2str(p1),' ',' -r ',num2str(p2),' '];
        otherwise
            LibSVMTrainOptions=[LibSVMTrainOptions,' -t 2 -g ',num2str(p1),' '];
    end
    LibSVMTrainOptions=[LibSVMTrainOptions,' -c ', num2str(C),' '];
    LibSVMTrainOptions=[LibSVMTrainOptions,' -m ', num2str(min(4*8*numsam*numsam/1e6,200)),' '];
    LibSVMTrainOptions=[LibSVMTrainOptions,' -e ', num2str(Tol),' '];
    
    model = svmtrain(y,x, LibSVMTrainOptions);
end



