function CK64_rowTest()
    load CK64_row;
    for i=1:471;
        temp = CK64_row(i,:);
        newPic = reshape(temp,64,64);
        imshow(newPic);
end
