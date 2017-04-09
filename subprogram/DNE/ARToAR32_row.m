function AR32_row=ARToAR32_row()
load ar;
AR32_row = zeros(2600,32*32);
for i=1:100   % ∂¡»°X_trn  
    acell  = X_trn{i};
    %imshow(acell);
    newPic = imresize(acell,[32,32]);
    %imshow(newPic);
    aline = reshape(newPic',1,32*32);
    AR32_row(i,:) = aline;
end

for i = 1:2500  %∂¡»°X_tst
    acell  = X_tst{i};
   % imshow(acell);
    newPic = imresize(acell,[32,32]);
    %imshow(newPic);
    aline = reshape(newPic',1,32*32);
    AR32_row(i+100,:) = aline;
end
AR32_row_Y(1:100,1) = Y_trn(1:100,1);
AR32_row_Y(101:2600,1) = Y_tst(1:2500,1);
save AR32_row.mat AR32_row;
save AR32_row_Y.mat AR32_row_Y;
end