clc
clear
close all

t=0.15;   %�źű���ʱ��
ts=0.001;  %����ʱ����
fc=250;  %�ز�Ƶ��
fs=1/ts;  %����Ƶ��
df=0.3;  %Ƶ�ʷֱ���
t1=[0:ts:t];  %ʱ������
m=[ones(1,t/(3*ts)),-2*ones(1,t/(3*ts)),zeros(1,t/(3*ts)+1)]; %�����ź�����
y=cos(2*pi*fc.*t1);  %�ز��ź�
u=m.*y;  %�����ź�

%�����Ӻ���fftseq
%function [M,m,df]=fftseq(m,tz,df)
fz=1/ts;

n1=fz/df;   %���ݲ������������Ƿ�ʹ��Ƶ������
n2=length(m);
n=2^(max(nextpow2(n1),nextpow2(n2)));

m=[m,zeros(1,n-n2)];
df1=fz/n;
n=fft(m,n);         %������ɢ����Ҷ�任

%[n,m,df1]=fftseq(m,ts,df); %ִ��fftseq�ӳ���
n=n/fs;
t=n;

%�����Ӻ���fftseq
%function [M,m,df]=fftseq(m,tz,df)
fz=1/ts;
n1=fz/df;   %���ݲ������������Ƿ�ʹ��Ƶ������
n2=length(u);
n=2^(max(nextpow2(n1),nextpow2(n2)));
ub=fft(u,n);         %������ɢ����Ҷ�任
u=[u,zeros(1,n-n2)];
df1=fz/n;


%[ub,u,df1]=fftseq(u,ts,df);
ub=ub/fs;
%[Y,y,df1]=fftseq(y,ts,df);
f=[0:df1:df1*(length(m)-1)]-fs/2;  %Ƶ������
subplot(2,2,1);
plot(t1,m(1:length(t1)));  %δ����ź�?
title('δ����ź�');
subplot(2,2,2);
plot(t1,u(1:length(t1))); %����ź�
title('����ź�');
subplot(2,2,3);
plot(f,abs(fftshift(t)));  %δ����ź�Ƶ��?
title('δ����ź�Ƶ��');
subplot(2,2,4);
plot(f,abs(fftshift(ub)));  %����ź�Ƶ��
title('����ź�Ƶ��');