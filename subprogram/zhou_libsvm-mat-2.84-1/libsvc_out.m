function [predict_label,accuracy,decvalorprob] = libsvc_out(x_tst,ker,model)
% testing for support vector machine for classification
%usage:
%[predict_label, accuracy, decvalorprob] = libsvcpredict(x, model, y,ProbabilityOn);
%predict_label  --          predicted label
%accuracy         --          predicting accuracy if y is provided
%decvalorprob  --          decision value of the c(c-1)/2 decision functions or predicted posterior probability for each class 
%x                     --          Testing examples
%model             --          Training results of lib SVM
%y                     --           the desired label
%ProbabilityOn --           The switch of whether the posterior probability
%prediction is on. when ProbabilityOn=1, it is required that the
%lib svm is trained with probability.
if nargin<2 | nargin>4
    help libsvcpredict
else
    if nargin<4,ProbabilityOn=0;,end
    if nargin<3,y=[];,end
    if ProbabilityOn==1 
        if ~isempty(model.ProbA) & ~isempty(model.ProbB)
            [predict_label, accuracy, decvalorprob] = svmpredict(y, x, model, '-b 1');
        else
            disp(' predicting with probability is ignored');
             [predict_label, accuracy, decvalorprob] = svmpredict(y, x, model, '-b 0');
        end
    else
        [predict_label, accuracy, decvalorprob] = svmpredict(y, x, model, '-b 0');
    end
end
        
        