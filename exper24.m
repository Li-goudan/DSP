%% 计算卷积

clc
clear
close all

N = 32;
n = 0:N-1;
% %第一组
% xn(1:15) = 1;
% xn(16:32) = 0;
% i = 0:14;
% hn(i+1) = (4/5).^i;
% hn(16:32) = 0;

% %第二组
% xn(1:10) = 1;
% xn(11:32) = 0;
% i = 0:19;
% hn(i+1) = 0.5*sin(0.5*i);
% hn(21:32) = 0;

%第三组
i = 0:9;
xn(i+1) = 1-0.1*i;
hn(i+1) = 0.1*i;
xn(11:32) = 0;
hn(11:32) = 0;
%调用自定义卷积函数
yn = conv(xn,hn);

%绘图
subplot(311);
stem(n,xn,'filled');
xlabel('n');
ylabel('x(n)');
subplot(312);
stem(n,hn,'filled');
xlabel('n');
ylabel('h(n)');
subplot(313);
m = 0:62;
stem(m,yn,'filled');
xlabel('n');
ylabel('y(n)');
%%
function [yn] = convs(xn,hn,N)
xk = fft(xn,N);
hk = fft(hn,N);
yk = xk .* hk;
yn = ifft(yk,N);
end