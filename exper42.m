%% FIR�����˲������

clc
clear
close all

%�Զ���
wp = 0.2*pi;
ws = 0.35*pi;
wc = (wp+ws)/2;
Ap = 1;
As = 15;
N = 15;
w = (0:255)/256;

%�����ͨ�ĳ弤��Ӧhdn
n=(0:N-1);
r = (N-1)/2;
hdn = sin(wc*(n-r))/pi./(n-r);
if rem(N,2)~=0
    hdn(r+1) = wc/pi;
end

subplot(2,2,1);
stem(n,hdn,'.');
title('����弤��Ӧ');
grid;
axis([0 N-1 -0.1 0.3]);
xlabel('|n|');
ylabel('Hd(n)');

%Blackman��
w_bla=blackman(N);
h_rec=hdn.*w_bla';
subplot(2,2,2);
stem(n,h_rec,'.');
title('ʵ�ʳ弤��Ӧ');
grid;
axis([0 N-1 -0.1 0.3]);
xlabel('|n|');
ylabel('H(n)');

% %�ԼӴ������н���DFT
% h_rec1 = fft(h_rec,512);

%��H(n)��ΪH(z)
h_rec1 = freqz(h_rec,1);

subplot(2,2,3);
w1 = (0:511)/512;
plot(w1,20*log10(abs(h_rec1)));
title('Blackman');
grid;
xlabel('��\piΪ��λ��Ƶ��');
ylabel('��������/dB');
set(gca,'XTickMode','manual','XTick',[0,0.2,0.35,1]);
set(gca,'YTickMode','manual','YTick',[-15,-1]);

subplot(2,2,4);
w1 = (0:511)/512;
plot(w1,angle(h_rec1));
title('��λ��Ӧ');
grid;
xlabel('��\piΪ��λ����λ');
ylabel('��λ');
set(gca,'YTickMode','manual','YTick',[-pi,pi]);