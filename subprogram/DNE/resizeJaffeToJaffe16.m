function Jaffe16 = resizeJaffeToJaffe16()
% resize Jaffe(64*64) to Jaffe16(16*16)
    load Jaffe;
    for i=1:213
        line = X(i,:);
        resTemp = reshape(line,64,64);
        newPic = imresize(resTemp,[16,16]);
        imshow(newPic);
        aline = reshape(newPic,1,16*16);
%         aline = reshape(aline,16,16);
%         imshow(aline);
        Jaffe16(i,:) = aline;
    end
    save Jaffe16.mat Jaffe16;
end