%% 计算卷积

clc
clear
close all

N = 32;
n = 0:N-1;
xn = [3,N];
hn = [3,N];

for z=1:3
    
%第一组
xn(1,1:15) = 1;
xn(1,16:32) = 0;
i = 0:14;
hn(1,i+1) = (4/5).^i;
hn(1,16:32) = 0;
yn(1,:) = conv(xn(1,:),hn(1,:));

%第二组
xn(2,1:10) = 1;
xn(2,11:32) = 0;
j = 0:19;
hn(2,j+1) = 0.5*sin(0.5*j);
hn(2,21:32) = 0;
yn(2,:) = conv(xn(2,:),hn(2,:));

%第三组
k = 0:9;
xn(3,k+1) = 1-0.1*k;
hn(3,k+1) = 0.1*k;
xn(3,11:32) = 0;
hn(3,11:32) = 0;
%调用卷积函数
yn(3,:) = conv(xn(3,:),hn(3,:));

%绘图
subplot(3,3,z)
stem(n,xn(z,:),'.');
xlabel('n');
ylabel('x(n)');
title("第"+num2str(z)+"组");

subplot(3,3,z+3)
stem(n,hn(z,:),'.');
xlabel('n');
ylabel('h(n)');

subplot(3,3,z+6);
m = 0:62;
stem(m,yn(z,:),'.');
xlabel('n');
ylabel('y(n)');

end