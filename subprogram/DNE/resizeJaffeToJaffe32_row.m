function Jaffe32_row = resizeJaffeToJaffe32_row()
% resize Jaffe(64*64) to Jaffe16(16*16)
    load Jaffe;
    for i=1:213
        line = X(i,:);
        resTemp = reshape(line,64,64);
        newPic = imresize(resTemp,[32,32]);
%         imshow(newPic);
        aline = reshape(newPic,1,32*32);
%         aline = reshape(aline,32,32);
%         imshow(aline);
        Jaffe32_row(i,:) = aline;
    end
    save Jaffe32_row.mat Jaffe32_row;
end