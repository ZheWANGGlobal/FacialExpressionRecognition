function jaffe32_row = ResizeTojaffe32_row()
    load Jaffe;
    jaffe32_row = zeros(213,32*32);
    for i=1:213
        line = X(i,:);
        resTemp = reshape(line,64,64);
        newPic = imresize(resTemp,[32,32]);
        imshow(newPic);
        aline = reshape(newPic,32*32,1);

end
