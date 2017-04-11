function image_lbp = originLBP( image )
%    这个函数是最初的LBP九宫格形式
%    参数image是待计算的原图
%    返回值image_lbp是经过计算的lbp图像

% image=imread('s1.png');
[row,column]=size(image);

image_lbp=zeros(row,column);

for i=2:row-1
    for j=2:column-1
       neighbour=image(i-1:i+1,j-1:j+1)>=image(i,j);
       image_lbp(i,j)=neighbour(1,1)*128+neighbour(1,2)*64+neighbour(1,3)*32+neighbour(2,1)*1+neighbour(2,3)*16+neighbour(3,1)*2+neighbour(3,2)*4+neighbour(3,3)*8;
    end
end
end

