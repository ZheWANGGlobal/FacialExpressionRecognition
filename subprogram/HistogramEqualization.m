function changeColor()
mydir1 = 'C:\Users\Administrator\Desktop\CKProc2\1\';
mydir2 = 'C:\Users\Administrator\Desktop\CKProc2\2\';
mydir3 = 'C:\Users\Administrator\Desktop\CKProc2\3\';
mydir4 = 'C:\Users\Administrator\Desktop\CKProc2\4\';
mydir5 = 'C:\Users\Administrator\Desktop\CKProc2\5\';
mydir6 = 'C:\Users\Administrator\Desktop\CKProc2\6\';
mydir7 = 'C:\Users\Administrator\Desktop\CKProc2\7\';
DIRS = dir([mydir7,'*.png']);
for i = 1 : 82
    str = [mydir7,DIRS(i).name];
    img = imread(str);
%     img=double(img)/255;
%     im = power(img,0.5);
    equ_image = histeq( img );
   imwrite(equ_image,str,'png');             
end
end