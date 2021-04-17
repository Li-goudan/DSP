%% IIR�����˲������

clc
clear
close all

%����Ƶ��ָ��wp = fp*2*pi*T
T=0.001;
Fs=1/T;
wp = 0.2*pi;
ws = 0.35*pi;
%ԭʼģ��Ƶ��
fp = wp/2/pi/T;
fs = ws/2/pi/T;
%ͨ�������˥��
Ap = 1;
As = 15;
W = (0:500)*pi/500;

%�����Ӧ����任��
[Nt,fc] = buttord(fp,fs,Ap,As,'s');
[Bt,At] = butter(Nt,2*pi*fc,'s');
[d,c] = impinvar(Bt,At,Fs);
[ht,ft] = freqz(d,c,W);

Ripplet=1/10^(Ap/20);
Attnt=1/10^(As/20);

subplot(211);
plot(W/pi,abs(ht),'DisplayName','�����Ӧ����任');
xlabel('��\piΪ��λ��Ƶ��');
ylabel('��ֵH');
title('��Ƶ��Ӧ');
set(gca,'XTickmode','manual','XTick',[0,0.2,0.35,1.1]);
set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;
subplot(212);
plot(W/pi,angle(ht),'DisplayName','�����Ӧ����任');
xlabel('��\piΪ��λ����λ');
ylabel('��λ');
title('��λ��Ӧ');
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1.1]);
% set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;