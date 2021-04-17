%% 对三种频率正弦波进行滤波处理

clc
clear 
close all

%自定义
wp = 0.2*pi;
ws = 0.35*pi;
wc = (wp+ws)/2;%0.275*pi
Ap = 1;
As = 15;
N = 40;
w = (0:255)/256;

%理想低通的冲激响应hdn
n=(0:N-1);
r = (N-1)/2;
hdn = sin(wc*(n-r))/pi./(n-r);
if rem(N,2)~=0
    hdn(r+1) = wc/pi;
end

%Blackman窗
w_bla=rectwin(N);
h_rec=hdn.*w_bla';
%由H(n)变为H(z)
h_rec1 = freqz(h_rec,1);

% %对加窗后序列进行DFT
% h_rec1 = fft(h_rec,512);

% %绘制幅度、相位特性曲线
% subplot(211);
% w1 = (0:511)/512;
% plot(w1,20*log10(abs(h_rec1)));
% title('Blackman');
% grid;
% xlabel('以\pi为单位的频率');
% ylabel('对数幅度/dB');
% set(gca,'XTickMode','manual','XTick',[0,0.2,0.35,1]);
% set(gca,'YTickMode','manual','YTick',[-15,-1]);
% subplot(212);
% plot(w1,angle(h_rec1));
% title('Blackman');
% grid;
% xlabel('以\pi为单位的频率');
% ylabel('对数幅度/dB');
% set(gca,'YTickMode','manual','YTick',[-pi,pi]);

f1=100;%0.1*pi
f2=500;%0.5*pi
f3=900;%0.9*pi
fs=2000;%待滤波正弦信号频率及采样频率 

figure;
subplot(2,2,1) 
%定义时间范围和步长
t=0:1/fs:0.1;
%滤波前信号
s=sin(2*pi*f1*t)+sin(2*pi*f2*t)+sin(2*pi*f3*t);
%滤波前的信号图像
plot(t,s);
xlabel('时间/秒');
ylabel('幅度');
title('信号滤波前时域图'); 

subplot(2,2,3)
%将信号变换到频域及信号频域图的幅值
Fs=fft(s,512); 
f=(0:255)*fs/512;%频率采样 
plot(f,abs(Fs(1:256)));%滤波前的信号频域图 
xlabel('频率/赫兹');
ylabel('幅度');
title('信号滤波前频域图'); 

%使用filter函数对信号进行滤波
sf=filter(h_rec1,1,s);

subplot(2,2,2)
%滤波后的信号图像
plot(t,abs(sf))
xlabel('时间/秒');
ylabel('幅度');
title('信号滤波后时域图');

subplot(2,2,4) ;
Fsf=fft(sf,512);
%滤波后的信号频域图及信号频域图的幅值 
plot(f,abs(Fsf(1:256)));
%滤波后的信号频域图 
xlabel('频率/赫兹');
ylabel('幅度');
title('信号滤波后频域图');