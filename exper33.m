%% 对三种频率正弦波进行滤波处理

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

%滤波
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
sf=filter(ht,1,s);

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