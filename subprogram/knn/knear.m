function judge=knear(k,sampleset,samplesign,testset)  %k：k近邻算法的k值，sampleset样本集，samplesign样本的标签，testset测试集
G=max(samplesign);
for i=1:size(testset,1);              %对检测样本矩阵每个向量进行如下操作
    for j=1:size(sampleset,1);           %计算待测向量与所有样本向量欧式距离（未开方）
        res(j,1)=(sampleset(j,:)-testset(i,:))*(sampleset(j,:)-testset(i,:))';
    end
    num(1:G,1)=0;
    for n=1:k;            %寻找k个res中最小的数值，根据其中种类1，2，3的个数判断这个向量属于第几类
        a=res(1,1);
        b=1;
        for j=1:size(sampleset,1);
            if a>res(j,1)         %设定a为第一个数值，循环，如果存在数值比它小，a=小的数值
                a=res(j,1);
                b=j;              %记录这个小数值所在的列数
            end
        end
        res(b,1)=256;             %找出这个数值的位置以后赋值256，以免重复查找
        num(samplesign(b,1),1)=num(samplesign(b,1),1)+1;
    end
    a=num(1,1);
    b=1;
    for j=1:G;
        if a<num(j,1)
           a=num(j,1);
           b=j;
        end
    end
    judge(i,1)=b;
          
end
%judge          %判断结果存入矩阵