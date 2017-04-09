%Training
%=================
%model = svmtrain(training_label_vector, training_instance_matrix, [,'libsvm_options']);
%         -training_label_vector:
%             An m by 1 vector of training labels.
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It can be dense or sparse.
%         -libsvm_options:
%             A string of training options in the same format as that of LIBSVM.
%             Training options:
%             -s svm_type : set type of SVM (default 0)
%                 0 -- C-SVC
%                 1 -- nu-SVC
%                 2 -- one-class SVM
%                 3 -- epsilon-SVR
%                 4 -- nu-SVR
%                 5 -- guest
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
%             -q beq: the right value of equation constraint 
%
%             The k in the -g option means the number of attributes in the input data.
% 
%             option -v randomly splits the data into n parts and calculates cross
%             validation accuracy/mean squared error on them.
%Testing
%=====================
%[predicted_label, accuracy, decision_values/prob_estimates] = svmpredict(testing_label_vector, testing_instance_matrix, model [,'libsvm_options']);

%         -testing_label_vector:
%             An m by 1 vector of prediction labels. If labels of test
%             data are unknown, simply use any random values.
%         -testing_instance_matrix:
%             An m by n matrix of m testing instances with n features.
%             It can be dense or sparse.
%         -model:
%             The output of svmtrain.
%         -libsvm_options:
%             A string of testing options in the same format as that of LIBSVM.
%             Test options:
%                 -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
%
% Returned Model Structure
% ========================
% 
% The 'svmtrain' function returns a model which can be used for future
% prediction.  It is a structure and is organized as [Parameters, nr_class,
% totalSV, rho, Label, ProbA, ProbB, nSV, sv_coef, SVs]:
% 
%         -Parameters: parameters
%         -nr_class: number of classes; = 2 for regression/one-class svm
%         -totalSV: total #SV
%         -rho: -b of the decision function(s) wx+b
%         -Label: label of each class; empty for regression/one-class SVM
%         -ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
%         -ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
%         -nSV: number of SVs for each class; empty for regression/one-class SVM
%         -sv_coef: coefficients for SVs in decision functions
%         -SVs: support vectors

% If you do not use the option '-b 1', ProbA and ProbB are empty
% matrices. If the '-v' option is specified, cross validation is
% conducted and the returned model is just a scalar: cross-validation
% accuracy for classification and mean-squared error for regression.
% 
% More details about this model can be found in LIBSVM FAQ
% (http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html) and LIBSVM
% implementation document
% (http://www.csie.ntu.edu.tw/~cjlin/papers/libsvm.pdf).
% 
% Result of Prediction
% ====================
% 
% The function 'svmpredict' has three outputs. The first one,
% predictd_label, is a vector of predicted labels. The second output,
% accuracy, is a vector including accuracy (for classification), mean
% squared error, and squared correlation coefficient (for regression).
% The third is a matrix containing decision values or probability
% estimates (if '-b 1' is specified). If k is the number of classes, for decision values, 
% each row includes results of predicting k(k-1/2) binary-class SVMs. For probabilities, 
% each row contains k values indicating the probability that the testing instance is in
% each class. Note that the order of classes here is the same as 'Label'
% field in the model structure.
% 
% Examples
% ========
% 
%Train and test on the provided data heart_scale:

load heart_scale.mat
num = length(heart_scale_label);
heart_scale_label = [heart_scale_label, rand(num, 3)]; 
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 2 -q 1.001');
[predict_label, accuracy, dec_values] = svmpredict(heart_scale_label, heart_scale_inst, model); % test the training data

%For probability estimates, you need '-b 1' for training and testing:

load heart_scale.mat
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 2 -b 1');
load heart_scale.mat
[predict_label, accuracy, prob_estimates] = svmpredict(heart_scale_label, heart_scale_inst, model, '-b 1');

% To use precomputed kernel, you must include sample serial number as
% the first column of the training and testing data (assume your kernel
% matrix is K, # of instances is n):

K1 = [(1:n)', K]; % include sample serial number as first column
model = svmtrain(label_vector, K1, '-t 4');
[predict_label, accuracy, dec_values] = svmpredict(label_vector, K1, model); % test the training data

% Take linear kernel for example, the following precomputed kernel example 
% gives exactly same training error as LIBSVM built-in linear kernel

load heart_scale.mat
n = size(heart_scale_inst,1);
K = heart_scale_inst*heart_scale_inst';
K1 = [(1:n)', K];
model = svmtrain(heart_scale_label, K1, '-t 4');
[predict_label, accuracy, dec_values] = svmpredict(heart_scale_label, K1, model);
       
% Note that for testing, you can put anything in the first column.  For
% details of precomputed kernels, please read the section ``Precomputed
% Kernels'' in the README of the LIBSVM package.
% 
% Other Utilities
% ===============
% 
% A matlab function read_sparse reads files in LIBSVM format: 

[label_vector, instance_matrix] = read_sparse('heart_scale.txt'); 

% Two outputs are labels and instances, which can then be used as inputs
% of svmtrain or svmpredict. This code is derived from svm-train.c in
% LIBSVM by Rong-En Fan from National Taiwan University.
% 
% Additional Information
% ======================
% 
% This interface was initially written by Jun-Cheng Chen, Kuan-Jen Peng,
% Chih-Yuan Yang and Chih-Huai Cheng from Department of Computer
% Science, National Taiwan University. The current version was prepared
% by Rong-En Fan and Ting-Fan Wu. If you find this tool useful, please
% cite LIBSVM as follows
% 
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm
% 
% For any question, please contact Chih-Jen Lin <cjlin@csie.ntu.edu.tw>.
% Or check the FAQ page:
% 
% http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#/Q9:_MATLAB_interface

% An example of classification of two class gaussian distributed samples on
% the 2-d space
numsam1=1000;
numsam2=1000;
numsam=numsam1+numsam2;
x1=randn(numsam1,2);
x2=randn(numsam2,2)+2;
x=[x1;x2];
y=[ones(numsam1,1);-ones(numsam2,1)];

figure(1);clf;
plot(x1(:,1),x1(:,2),'r.');
hold on;
plot(x2(:,1),x2(:,2),'b+');
ker='linear';
C=10;
global p1 p2;
K=KGram(ker,x,x);
model = svmtrain(y,[[1:numsam]',K], '-s 0 -t 4 -d 1 -g 1 -r 0 -c 10 -n 1 -p 0 -m 50 -e 0.000001 -h 0 -b 1');%-w1 10 -w2 4 -v
model.SVs=x(model.SVs,:);
figure(2);clf;
libsvcplot(x,y,ker,model.SVs,model.sv_coef,model.rho);

[predict_label, accuracy, prob_estimates] = svmpredict(y, x, model, '-b 1');

