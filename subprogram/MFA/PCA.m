%功能：PCA 提取表情图片之间最有鉴别力的特征
%函数参数：包含一种表情所有训练图像的矩阵T
%返回：A- 集中了图像向量的64*64*n的矩阵 n是当前图库的图片数
%      Eigenfaces-  训练图库的协方差矩阵的(64*64x(n-1))的特征向量（特征脸）
%      m- 训练图库的均值图像
function [m, A, Eigenfaces] = PCA(T)
    %先计算均值图像
    m = mean(T,2); %  返回T中沿着列上的元素的平均值 m = (1/n)*sum(Tj's)    (j = 1 : n) 返回T中第二维的元素的平均值
    Train_Number = size(T,2);

    %计算每张图相对于平均图的偏差
    A = [];  
    for i = 1 : Train_Number
        temp = double(T(:,i)) - m; % 计算训练集中每张图片的偏差 Ai = Ti - m
        A = [A temp]; % 将计算得出的偏差向量归并起来
    end

    L = A'*A; % L代表协方差矩阵 C=A*A'
    [V D] = eig(L); % 矩阵D的对角元素是L=A'*A 和 C=A*A' 的特征值 L的特征值向量构成V，A全部特征值构成对角阵D

    %排序并消除特征值
    %矩阵L所有的特征值是有序的  小于指定阈值的特征值将被消除，故非零特征向量的数量可能小于n-10
    L_eig_vec = [];
    for i = 1 : size(V,2)  %矩阵V的列数
        if( D(i,i)>1 )
            L_eig_vec = [L_eig_vec V(:,i)];
        end
    end

%计算协方差矩阵C的特征向量（即特征脸），用L来恢复C的特征脸
Eigenfaces = A * L_eig_vec; % A: 集中的图片向量


