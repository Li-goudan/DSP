%% ������Ƶ�����Ҳ������˲�����

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

%�˲�
f1=100;%0.1*pi
f2=500;%0.5*pi
f3=900;%0.9*pi
fs=2000;%���˲������ź�Ƶ�ʼ�����Ƶ�� 

figure;
subplot(2,2,1) 
%����ʱ�䷶Χ�Ͳ���
t=0:1/fs:0.1;
%�˲�ǰ�ź�
s=sin(2*pi*f1*t)+sin(2*pi*f2*t)+sin(2*pi*f3*t);
%�˲�ǰ���ź�ͼ��
plot(t,s);
xlabel('ʱ��/��');
ylabel('����');
title('�ź��˲�ǰʱ��ͼ'); 

subplot(2,2,3)
%���źű任��Ƶ���ź�Ƶ��ͼ�ķ�ֵ
Fs=fft(s,512); 
f=(0:255)*fs/512;%Ƶ�ʲ��� 
plot(f,abs(Fs(1:256)));%�˲�ǰ���ź�Ƶ��ͼ 
xlabel('Ƶ��/����');
ylabel('����');
title('�ź��˲�ǰƵ��ͼ'); 

%ʹ��filter�������źŽ����˲�
sf=filter(ht,1,s);

subplot(2,2,2)
%�˲�����ź�ͼ��
plot(t,abs(sf))
xlabel('ʱ��/��');
ylabel('����');
title('�ź��˲���ʱ��ͼ');

subplot(2,2,4) ;
Fsf=fft(sf,512);
%�˲�����ź�Ƶ��ͼ���ź�Ƶ��ͼ�ķ�ֵ 
plot(f,abs(Fsf(1:256)));
%�˲�����ź�Ƶ��ͼ 
xlabel('Ƶ��/����');
ylabel('����');
title('�ź��˲���Ƶ��ͼ');