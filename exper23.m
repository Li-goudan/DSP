%% DFT��FFTʱ��Ա�

clc
clear
close all
%��ʼֵ
F = 50;
N = 32;
k = (0:(N-1));
%����0.000625
l = 0.000625;
t = (0:l:l*(N-1));
%xΪ��ɢʱ������
x = cos(2 * pi * F .* t);

subplot(311);
stem(k,x,'filled');
xlabel('n');
ylabel('x(n)');
title('��ɢ����');
%axis([0 (N-1) -2 2]);

%FFT��ʱ
tic;
y0 = fft(x,N);
toc;
%DFT��ʱ
tic;
y1 = dft(x,N);
toc;

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
%n'Ϊn��ת��
nk = n'*k;
Xk=xn * exp(-1i * 2 * pi / N) .^ nk;
end