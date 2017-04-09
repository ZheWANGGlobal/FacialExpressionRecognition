figure(1);clf;
hold on;
for k1=1:length(numset)
for k2=1:length(Cset)
    for k3=1:length(pset)
        A(k2,k3)=recrate(k1,k2,k3,1);
        B(k2,k3)=recrate(k1,k2,k3,2);
    end
end
figure(1);clf;
hold on;
mesh(log2(pset),log2(Cset),A);

mesh(log2(pset),log2(Cset),B);

end