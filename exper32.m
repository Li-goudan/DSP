%% IIR Filter冲击响应不变变换&双线性变换

clc
clear
close all

%原始模拟频率
fp = 200;
fs = 300;
%数字频率指标wp = fp*2*pi*T
T=0.001;
Fs=1/T;
wp = fp*2*pi*T;
ws = fs*2*pi*T;
Ap = 1;
As = 25;
W = (0:500)*pi/500;

%冲击响应不变变换法
[Nt,fc] = buttord(fp,fs,Ap,As,'s');
[Bt,At] = butter(Nt,2*pi*fc,'s');
[d,c] = impinvar(Bt,At,Fs);
[ht,ft] = freqz(d,c,W);

Ripplet=1/10^(Ap/20);
Attnt=1/10^(As/20);
%预畸变
OmegaP=(2/T)*tan(wp/2);
OmegaS=(2/T)*tan(ws/2);
%计算通带截频和阻带截频对应的幅值Ripple&Attn
Ripple=1/10^(Ap/20);
Attn=1/10^(As/20);

%ceil朝正无穷大四舍五入到大于或等于该元素的最接近整数
N=ceil((log10((10^(Ap/10)-1)/(10^(As/10)-1)))/(2*log10(OmegaP/OmegaS)));
OmegaC=OmegaP/((10.^(Ap/10)-1).^(1/(2*N)));
%或者用buttord()函数直接求出N&OmegaC
%[N,OmegaC] = buttord(OmegaP,OmegaS,Ap,As,'s');

%B&A是H(s)的多项式，b&a是H(z)的多项式
[B,A] = butter(N,OmegaC,'s');
%biliner()函数双线性变换将H(s)转化为H(z)
[b,a]=bilinear(B,A,Fs);
% [mag,db,pha,w]=freqz_m(b,a);

[h,f] = freqz(b,a,W);

% subplot(3,1,1);
% plot(W/pi,abs(h)/abs(h(1)));
% title('双线性变换');
% xlabel('w(pi)');
% ylabel('H');
% axis([0,1,0,1.1]);
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1]);
% set(gca,'YTickmode','manual','YTick',[0,Attn,Ripple,1]);
% grid;
% 
% subplot(3,1,2);
% plot(W/pi,abs(ht));
% title('冲击响应不变变换');
% xlabel('w(pi)');
% ylabel('H');
% axis([0,1,0,1.1]);
% set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1]);
% set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
% grid;

%subplot(3,1,3);
plot(W/pi,abs(ht),'DisplayName','冲击响应不变变换');
hold on
plot(W/pi,abs(h),'DisplayName','双线性变换');
title('对比');
xlabel('w(pi)');
ylabel('数字滤波器');
axis([0,1,0,1.1]);
set(gca,'XTickmode','manual','XTick',[0,0.4,0.6,1.1]);
set(gca,'YTickmode','manual','YTick',[0,Attnt,Ripplet,1]);
grid;
legend('冲击响应不变变换','双线性变换');
hold off