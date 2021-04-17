%% ������Ƶ�����Ҳ������˲�����

clc
clear 
close all

%�Զ���
wp = 0.2*pi;
ws = 0.35*pi;
wc = (wp+ws)/2;%0.275*pi
Ap = 1;
As = 15;
N = 40;
w = (0:255)/256;

%�����ͨ�ĳ弤��Ӧhdn
n=(0:N-1);
r = (N-1)/2;
hdn = sin(wc*(n-r))/pi./(n-r);
if rem(N,2)~=0
    hdn(r+1) = wc/pi;
end

%Blackman��
w_bla=rectwin(N);
h_rec=hdn.*w_bla';
%��H(n)��ΪH(z)
h_rec1 = freqz(h_rec,1);

% %�ԼӴ������н���DFT
% h_rec1 = fft(h_rec,512);

% %���Ʒ��ȡ���λ��������
% subplot(211);
% w1 = (0:511)/512;
% plot(w1,20*log10(abs(h_rec1)));
% title('Blackman');
% grid;
% xlabel('��\piΪ��λ��Ƶ��');
% ylabel('��������/dB');
% set(gca,'XTickMode','manual','XTick',[0,0.2,0.35,1]);
% set(gca,'YTickMode','manual','YTick',[-15,-1]);
% subplot(212);
% plot(w1,angle(h_rec1));
% title('Blackman');
% grid;
% xlabel('��\piΪ��λ��Ƶ��');
% ylabel('��������/dB');
% set(gca,'YTickMode','manual','YTick',[-pi,pi]);

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
sf=filter(h_rec1,1,s);

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