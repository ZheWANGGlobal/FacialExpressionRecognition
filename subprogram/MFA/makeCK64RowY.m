function CKROW_Y=makeCK64RowY()
cell = {44,18,57,17,69,27,82};
%  CKROW_Y = zeros(314,1);
load CKROW_Y;
for i =233:314
    CKROW_Y(i,1) = 7;
    save CKROW_Y.mat CKROW_Y;
end
end