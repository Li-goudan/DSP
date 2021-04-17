%% ��Ƶ��Ƶ��������

clc
clear
close all

% b=[0.0181,0.0543,0.0543,0.0181];
% a=[1.000,-1.76,1.1829,-0.2781];
b=[1,-2,3];
a=[1,-2,1];

%��ϵͳ����
[h,w] = freqz(b,a);
%��Ƶ����Hf
Hf = abs(h);
%��Ƶ����Hx
Hx = angle(h);

subplot(2,1,1);
plot(w./pi,Hf);
%������
grid on;
xlabel('w(pi)');
ylabel('|H|');
title('��Ƶ��������');

subplot(2,1,2);
plot(w./pi,Hx);
grid on;
xlabel('w(pi)');
ylabel('angle(H)');
title('��Ƶ��������');