% This make.m is used under Windows

%mex -O -c .\src\svm.cpp -I.\include -outdir .\obj 
%mex -O -c .\src\svm_model_matlab.c -I.\include -outdir .\obj
mex -O .\src\svmtrain.c .\src\svm.cpp .\src\svm_model_matlab.c -I.\include
mex -O .\src\svmpredict.c .\src\svm.cpp .\src\svm_model_matlab.c -I.\include
mex -O .\src\read_sparse.c -I.\include
