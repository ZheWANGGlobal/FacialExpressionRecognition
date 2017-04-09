function YaleB32_row=yale_bToYaleB32_row()
load yale-b;
YaleB32_row = zeros(2394+38,32*32);
for i=1:38   % ∂¡»°X_trn  
    acell  = X_trn(i,1);
    amat = cell2mat(acell);
    %imshow(amat);
    newPic = imresize(amat,[32,32]);
    %imshow(newPic);
    aline = reshape(newPic,1,32*32);
    YaleB32_row(i,:) = aline;
end

for i = 1:2394  %∂¡»°X_tst
    acell  = X_tst(i,1);
    amat = cell2mat(acell);
    %imshow(amat);
    newPic = imresize(amat,[32,32]);
    %imshow(newPic);
    aline = reshape(newPic,1,32*32);
    YaleB32_row(i+38,:) = aline;
end
save YaleB32_row.mat YaleB32_row;
end