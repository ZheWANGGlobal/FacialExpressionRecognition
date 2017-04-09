function CK_Y=createCK_Y()
cell = {57,46,79,109,79,101};
% CK_Y = zeros(471,1);
load CK_Y;
for i =371:471
    CK_Y(i,1) = 6;
    save CK_Y.mat CK_Y;
end
end