function x_new=changeXRow2XCol(x)
    [n,d] = size(x);
    x_new = zeros(d,n);
    for i=1:n
       aline = x(i,:);
       acol = aline';
       x_new(:,i) = acol; 
    end

end