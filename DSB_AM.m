clc
clear
close all

t=0.15;   %信号保持时间
ts=0.001;  %采样时间间隔
fc=250;  %载波频率
fs=1/ts;  %采样频率
df=0.3;  %频率分辩率
t1=[0:ts:t];  %时间向量
m=[ones(1,t/(3*ts)),-2*ones(1,t/(3*ts)),zeros(1,t/(3*ts)+1)]; %定义信号序列
y=cos(2*pi*fc.*t1);  %载波信号
u=m.*y;  %调制信号

%定义子函数fftseq
%function [M,m,df]=fftseq(m,tz,df)
fz=1/ts;

n1=fz/df;   %根据参数个数决定是否使用频率缩放
n2=length(m);
n=2^(max(nextpow2(n1),nextpow2(n2)));

m=[m,zeros(1,n-n2)];
df1=fz/n;
n=fft(m,n);         %进行离散傅里叶变换

%[n,m,df1]=fftseq(m,ts,df); %执行fftseq子程序
n=n/fs;
t=n;

%定义子函数fftseq
%function [M,m,df]=fftseq(m,tz,df)
fz=1/ts;
n1=fz/df;   %根据参数个数决定是否使用频率缩放
n2=length(u);
n=2^(max(nextpow2(n1),nextpow2(n2)));
ub=fft(u,n);         %进行离散傅里叶变换
u=[u,zeros(1,n-n2)];
df1=fz/n;


%[ub,u,df1]=fftseq(u,ts,df);
ub=ub/fs;
%[Y,y,df1]=fftseq(y,ts,df);
f=[0:df1:df1*(length(m)-1)]-fs/2;  %频率向量
subplot(2,2,1);
plot(t1,m(1:length(t1)));  %未解调信号?
title('未解调信号');
subplot(2,2,2);
plot(t1,u(1:length(t1))); %解调信号
title('解调信号');
subplot(2,2,3);
plot(f,abs(fftshift(t)));  %未解调信号频谱?
title('未解调信号频谱');
subplot(2,2,4);
plot(f,abs(fftshift(ub)));  %解调信号频谱
title('解调信号频率');