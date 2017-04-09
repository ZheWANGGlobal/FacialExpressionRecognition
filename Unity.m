% 将人脸图片归一化 根据两眼来切割出人脸区域
function Unitery(num) %height,width是目标图片的长宽，m是图片个数
    clear; % 删除工作空间中的项目，释放系统内存
    close all;%关闭所有figure窗口

    % set the number of the images
    num = 82;
    % set the path of the images
    mydir = 'C:\Users\Administrator\Desktop\CKPic\7\';
    % set suffix
    DIRS = dir([mydir,'*.png']);  % dir函数取字符串目录下的文件
    
    % 遍历每张图 进行分割
    for i=1:num
        str1 = [mydir,DIRS(i).name];% 依次获得每张表情图的路径
        eval('OriImg=imread(str1)'); %执行字符串每次循环读入img %读入图像
        figure,imshow(OriImg),[x,y] = ginput(2); %手工获取人眼E1，E2的坐标
        d = x(2,1)-x(1,1);   %计算两眼之间的宽度d
        
        % 求E1,E2的中心O(Ox,Oy)
        Ox = sum(x)/2;
        Oy = sum(y)/2;
        
        % 切割人脸
%         I1 = imcrop(OriImg,[Ox-d Oy-0.5*d 2*d 2*d]); 
        I1 = imcrop(OriImg,[Ox-0.75*d Oy-0.4*d 1.5*d 2*d]); 
        
        %resize图片
        I1=imresize(I1,[64,64]);
        str2 = strcat('C:\Users\Administrator\Desktop\CKProc\7\',DIRS(i).name);
        eval('imwrite(I1,str2);'); % 执行字符串 每次循环读入img %读入图像 %保存归一化后的图像
        close all;
    end
end