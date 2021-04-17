%% ���ֲ���Ƶ��FFT�Ա�

clc
clear
close all
%��ʼֵ
F = 50;
N = 32;
k = (0:(N-1));
%4�ֲ���
l = [0.000625 0.005 0.0046875 0.004];
test = l.*(N-1);

%����ǰ4��
for i = 1:4
    t = linspace(0,test(i),N+1);
    %t = (0:l(i):test(i));
    %xΪ��ɢʱ������
    x = cos(2 * pi * F .* t);
    y = fft(x,N);
    subplot(3,2,i);
    stem(k,abs(y),'filled');
    title(['N=32, l=',num2str(l(i))]);        
end

%���Ƶ�5��
N2 = 64;
k2 = (0:(N2-1));
t2 = (0:l(1):l(1)*N2);
%xΪ��ɢʱ������
x = cos(2 * pi * F .* t2);
y = fft(x,N2);
subplot(3,1,3);
stem(k2,abs(y),'filled');
title(['N=64, l=',num2str(l(1))]);