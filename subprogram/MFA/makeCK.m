function CK64Row=createCKDatabase()
mydir1 = 'C:\Users\Administrator\Desktop\CKProc\1\';
mydir2 = 'C:\Users\Administrator\Desktop\CKProc\2\';
mydir3 = 'C:\Users\Administrator\Desktop\CKProc\3\';
mydir4 = 'C:\Users\Administrator\Desktop\CKProc\4\';
mydir5 = 'C:\Users\Administrator\Desktop\CKProc\5\';
mydir6 = 'C:\Users\Administrator\Desktop\CKProc\6\';
mydir7 = 'C:\Users\Administrator\Desktop\CKProc\7\';
DIRS = dir([mydir7,'*.png']);
%  
% CK64Row = [];
load CK64Row;
for i = 1 : 82
    str = [mydir7,DIRS(i).name];
    img = imread(str);
    temp = reshape(img,1,64*64);   %将二维图像转成一维向量
    pic = reshape(temp,64,64);
    imshow(pic);
    CK64Row = [CK64Row;temp]; % 'T' 随着循环依次增长                   
end

save CK64Row.mat CK64Row
end