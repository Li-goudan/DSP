%% DFT与FFT时间对比

clc
clear
close all
%初始值
F = 50;
N = 128;
k = (0:(N-1));
%步长0.000625
l = 0.000625;
t = (0:l:l*(N-1));
%x为离散时间序列
x = cos(2 * pi * F .* t);

subplot(311);
stem(k,x,'filled');
xlabel('n');
ylabel('x(n)');
title('离散序列');
%axis([0 (N-1) -2 2]);

%FFT计时
t0start=tic;
y0 = fft(x,N);
t0end=toc(t0start);
disp("FFT needs "+t0end+'s');

%DFT计时
t1start=tic;
y1 = dft(x,N);
t1end=toc(t1start);
disp("DFT needs "+t1end+'s');

subplot(312);
stem(k,abs(y0),'filled')
xlabel('f');
%ylabel('x(n)');
title('DFT');
%axis([-(N-1)/2 (N-1)/2 0 40]);

subplot(313);
stem(k,abs(y1),'filled')
xlabel('f');
%ylabel('');
title('FFT');
%axis([-(N-1)/2 (N-1)/2 0 40]);
%%
function [Xk] = dft(xn,N)
n = 0:N-1;
k = 0:N-1;
%n'为n的转置
nk = n'*k;
Xk=xn * exp(-1i * 2 * pi / N) .^ nk;
end