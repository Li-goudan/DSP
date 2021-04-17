%% FIR数字滤波器设计

clc
clear
close all

%自定义
wp = 0.2*pi;
ws = 0.35*pi;
wc = (wp+ws)/2;
Ap = 1;
As = 15;
N = 15;
w = (0:255)/256;

%理想低通的冲激响应hdn
n=(0:N-1);
r = (N-1)/2;
hdn = sin(wc*(n-r))/pi./(n-r);
if rem(N,2)~=0
    hdn(r+1) = wc/pi;
end

subplot(2,2,1);
stem(n,hdn,'.');
title('理想冲激响应');
grid;
axis([0 N-1 -0.1 0.3]);
xlabel('|n|');
ylabel('Hd(n)');

%Blackman窗
w_bla=blackman(N);
h_rec=hdn.*w_bla';
subplot(2,2,2);
stem(n,h_rec,'.');
title('实际冲激响应');
grid;
axis([0 N-1 -0.1 0.3]);
xlabel('|n|');
ylabel('H(n)');

% %对加窗后序列进行DFT
% h_rec1 = fft(h_rec,512);

%由H(n)变为H(z)
h_rec1 = freqz(h_rec,1);

subplot(2,2,3);
w1 = (0:511)/512;
plot(w1,20*log10(abs(h_rec1)));
title('Blackman');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');
set(gca,'XTickMode','manual','XTick',[0,0.2,0.35,1]);
set(gca,'YTickMode','manual','YTick',[-15,-1]);

subplot(2,2,4);
w1 = (0:511)/512;
plot(w1,angle(h_rec1));
title('相位响应');
grid;
xlabel('以\pi为单位的相位');
ylabel('相位');
set(gca,'YTickMode','manual','YTick',[-pi,pi]);