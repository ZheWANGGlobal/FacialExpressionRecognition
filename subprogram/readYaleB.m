%将yale-b.mat文件变为YaleBThirtyTwo（32*32）*2432和YaleB_Y 2432*1
load yale-b;
YaleBThirtyTwo = zeros(32*32,2394+38);
YaleB_Y = zeros(2394+38,1);
for i=1:38   % 读取X_trn  
    acell  = X_trn(i,1);
    amat = cell2mat(acell);
    %imshow(amat);
    newPic = imresize(amat,[32,32]);
    %imshow(newPic);
    acol = reshape(newPic,32*32,1);
    YaleBThirtyTwo(:,i) = acol;
end

for i = 1:2394
    acell  = X_tst(i,1);
    amat = cell2mat(acell);
    %imshow(amat);
    newPic = imresize(amat,[32,32]);
    %imshow(newPic);
    acol = reshape(newPic,32*32,1);
    YaleBThirtyTwo(:,i+38) = acol;
end

YaleB_Y(1:38,1) = Y_trn(1:38,1);
YaleB_Y(39:2432,1) = Y_tst(1:2394,1);
save YaleBThirtyTwo.mat YaleBThirtyTwo;
save YaleB_Y.mat YaleB_Y;