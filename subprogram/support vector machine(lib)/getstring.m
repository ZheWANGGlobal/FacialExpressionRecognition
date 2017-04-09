function [string]=getstring(ker,C)
global p1
switch lower(ker)
        case 'linear'
            kernum=0;
            string=['-t ',num2str(kernum'),' -c ', num2str(C)];
        case 'poly'
            kernum=1;
            string=['-t ',num2str(kernum'),' -c ', num2str(C),'-d ', num2str(p1)];
        case 'rbf'
            kernum=2;
            string=['-t ',num2str(kernum'),' -c ', num2str(C),' -g ',num2str(p1)];
end
