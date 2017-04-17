function x_new = changeXCol2XRow(x)
    [d,n] = size(x);
    x_new = zeros(n,d);
    for i=1:n
        aline = x(:,i);
        acol = aline';
        x_new(i,:) = acol;
    end
end