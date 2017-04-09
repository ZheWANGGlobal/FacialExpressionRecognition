function res=shrink(y,a)
    res = zeros(size(y));
    index = find(abs(y)>a);
    res(index) = sign(y(index)).*(abs(y(index)-a));