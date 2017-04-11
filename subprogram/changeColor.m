function changeColor()
mydir1 = 'C:\Users\Administrator\Desktop\CKProc3\1\';
mydir2 = 'C:\Users\Administrator\Desktop\CKProc3\2\';
mydir3 = 'C:\Users\Administrator\Desktop\CKProc3\3\';
mydir4 = 'C:\Users\Administrator\Desktop\CKProc3\4\';
mydir5 = 'C:\Users\Administrator\Desktop\CKProc3\5\';
mydir6 = 'C:\Users\Administrator\Desktop\CKProc3\6\';
mydir7 = 'C:\Users\Administrator\Desktop\CKProc3\7\';
DIRS = dir([mydir7,'*.png']);
for i = 1 : 82
    str = [mydir7,DIRS(i).name];
    img = imread(str);
    img=double(img)/255;
    im = power(img,0.5);
   imwrite(im,str,'png');             
end
end