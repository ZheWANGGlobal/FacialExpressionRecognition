function CK64Row=createCKDatabase()
mydir1 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\anger\';
mydir2 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\disgust\';
mydir3 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\fear\';
mydir4 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\happiness\';
mydir5 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\sadness\';
mydir6 = 'C:\Users\Administrator\Desktop\PCA+KNN\newCK\surprise\';
DIRS = dir([mydir1,'*.png']);
%  
 CK64_row = [];
% load CK64_row;
for i = 1 : 44
    str = [mydir1,DIRS(i).name];
    img = imread(str);
    temp = reshape(img,1,64*64);   %将二维图像转成一维向量
%     pic = reshape(temp,64,64);
%     imshow(pic);
    CK64_row = [CK64_row;temp]; % 'T' 随着循环依次增长                   
end

save CK64Row.mat CK64Row
end