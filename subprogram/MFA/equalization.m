% function equ_imageLBP = equalization( imgLBP, n )
function equ_image = equalization( image )
%%%%%%%%%%%%%%%%%%%%%%%%
%   这个函数是直方图均衡化的实现
%   参数image是需要处理的函数
%   返回值equ_image是均衡化之后的图片

% image=imread('s1.png');
% subplot(1,2,1);
% imshow(uint8(image));
[row,column] = size(image);

%统计像素值的分布密度
pixelNum=zeros(1,256);
for i=0:255
    pixelNum(i+1)=length(find(image==i))/(row*column*1.0);
end

%计算直方图分布
pixelEqualize=zeros(1,256);
for i=1:256
    if i==1
        pixelEqualize(i)=pixelNum(i);
    else
        pixelEqualize(i)=pixelEqualize(i-1)+pixelNum(i);
    end
end

%取整
pixelEqualize=round(256 .* pixelEqualize +0.5);

%均衡化
for i=1:row
    for j=1:column
        equ_image(i,j)=pixelEqualize(image(i,j)+1);
    end
end

% subplot(1,2,2);
% imshow(uint8(equ_image));
end

