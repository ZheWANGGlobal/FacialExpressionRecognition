function CK32Row_power=changeCK64Row2CK32Row()
load CK64Row_power;
CK32Row_power = zeros(314,32*32);
for i=1:314   % ∂¡»°X_trn  
    amat  = CK64Row_power(i,:);
     pic = reshape(amat,64,64);
%     imshow(pic);
    newPic = imresize(pic,[32,32]);
%     imshow(newPic);
    aline = reshape(newPic,1,32*32);
    pic = reshape(aline,32,32);
    imshow(pic);
    CK32Row_power(i,:) = aline;
end
save CK32Row_power.mat CK32Row_power;
end