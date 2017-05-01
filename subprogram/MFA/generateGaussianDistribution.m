mu = [2 3];
SIGMA = [1 0; 0 2];
r = mvnrnd(mu,SIGMA,100);
plot(r(:,1),r(:,2),'r+');
hold on;
mu = [7 8];
SIGMA = [ 1 0; 0 2];
r2 = mvnrnd(mu,SIGMA,100);
plot(r2(:,1),r2(:,2),'*')



%randn生成均值0方差1的随机数
% blue=randn(100,2)+3.5;
% red=randn(10,2)+1;
% plot(blue(:,1),blue(:,2),'blue*',red(:,1),red(:,2),'red*')

% 
% m=50;
% n=2;
% x=0:1:100;
% y=exp(-(x-m).^2/(2*n^2));
% subplot(2,1,1)
% plot(x,y)
% subplot(2,1,2)
% % z=normrnd(50,2,100,1);
% % plot(z)
% z=0:1:100; 
% d=normpdf(z,50,2); 
% plot(z,d)
