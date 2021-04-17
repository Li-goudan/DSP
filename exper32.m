%% IIR Filter�����Ӧ����任&˫���Ա任

clc
clear
close all

%ԭʼģ��Ƶ��
fp = 200;
fs = 300;
%����Ƶ��ָ��wp = fp*2*pi*T
T=0.001;
Fs=1/T;
wp = fp*2*pi*T;
ws = fs*2*pi*T;
Ap = 1;
As = 25;
W = (0:500)*pi/500;

%�����Ӧ����任��
[Nt,fc] = buttord(fp,fs,Ap,As,'s');
[Bt,At] = butter(Nt,2*pi*fc,'s');
[d,c] = impinvar(Bt,At,Fs);
[ht,ft] = freqz(d,c,W);

Ripplet=1/10^(Ap/20);
Attnt=1/10^(As/20);
%Ԥ����
OmegaP=(2/T)*tan(wp/2);
OmegaS=(2/T)*tan(ws/2);
%����ͨ����Ƶ�������Ƶ��Ӧ�ķ�ֵRipple&Attn
Ripple=1/10^(Ap/20);
Attn=1/10^(As/20);

%ceil����������������뵽���ڻ���ڸ�Ԫ�ص���ӽ�����
N=ceil((log10((10^(Ap/10)-1)/(10^(As/10)-1)))/(2*log10(OmegaP/OmegaS)));
OmegaC=OmegaP/((10.^(Ap/10)-1).^(1/(2*N)));
%������buttord()����ֱ�����N&OmegaC
%[N,OmegaC] = buttord(OmegaP,OmegaS,Ap,As,'s');

%B&A��H(s)�Ķ���ʽ��b&a��H(z)�Ķ���ʽ
[B,A] = butter(N,OmegaC,'s');
%biliner()����˫���Ա任��H(s)ת��ΪH(z)
[b,a]=bilinear(B,A,Fs);
% [mag,db,pha,w]=freqz_m(b,a);

[h,f] = freqz(b,a,W);

% subplot(3,1,1);
% plot(W/pi,abs(h)/abs(h(1)));
% title('˫���Ա任');
% xlabel('w(pi)');
% ylabel('H');
% axis([0,1,0,1.1]);
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1]);
% set(gca,'YTickmode','manual','YTick',[0,Attn,Ripple,1]);
% grid;
% 
% subplot(3,1,2);
% plot(W/pi,abs(ht));
% title('�����Ӧ����任');
% xlabel('w(pi)');
% ylabel('H');
% axis([0,1,0,1.1]);
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1]);
% set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
% grid;

%subplot(3,1,3);
plot(W/pi,abs(ht),'DisplayName','�����Ӧ����任');
hold on
plot(W/pi,abs(h),'DisplayName','˫���Ա任');
title('�Ա�');
xlabel('w(pi)');
ylabel('�����˲���');
axis([0,1,0,1.1]);
set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1.1]);
set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;
legend('�����Ӧ����任','˫���Ա任');
hold off