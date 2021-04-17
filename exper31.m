%% IIR数字滤波器设计

clc
clear
close all

%数字频率指标wp = fp*2*pi*T
T=0.001;
Fs=1/T;
wp = 0.2*pi;
ws = 0.35*pi;
%原始模拟频率
fp = wp/2/pi/T;
fs = ws/2/pi/T;
%通带和阻带衰减
Ap = 1;
As = 15;
W = (0:500)*pi/500;

%冲击响应不变变换法
[Nt,fc] = buttord(fp,fs,Ap,As,'s');
[Bt,At] = butter(Nt,2*pi*fc,'s');
[d,c] = impinvar(Bt,At,Fs);
[ht,ft] = freqz(d,c,W);

Ripplet=1/10^(Ap/20);
Attnt=1/10^(As/20);

subplot(211);
plot(W/pi,abs(ht),'DisplayName','冲击响应不变变换');
xlabel('以\pi为单位的频率');
ylabel('幅值H');
title('幅频响应');
set(gca,'XTickmode','manual','XTick',[0,0.2,0.35,1.1]);
set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;
subplot(212);
plot(W/pi,angle(ht),'DisplayName','冲击响应不变变换');
xlabel('以\pi为单位的相位');
ylabel('相位');
title('相位响应');
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1.1]);
% set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;