function [TY]=changelabel(Y)
%%
classnum=unique(Y);
TY=Y;
if length(classnum)==2
    for i=1:length(classnum)
        in=find(Y==classnum(i));
        TY(in)=i;
    end
end

