%% 五种窗函数比较

clc
clear
close all

w1=0.3*pi;
w2=0.5*pi;
N=32;
wc=(w1+w2)/2;
w = (0:255)/256;

%理想低通的冲激响应hdn
n=(0:N-1);
r = (N-1)/2;
hdn = sin(wc*(n-r))/pi./(n-r);
if rem(N,2)~=0
    hdn(r+1) = wc/pi;
end

%矩形窗
w_rec=rectwin(N);
h_rec=hdn.*w_rec';
%对加窗后序列进行DFT
h_rec1 = fft(h_rec,512);
subplot(3,2,1);
plot(w,20*log10(abs(h_rec1(1:256))));
title('矩形窗');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');axis([0 1 -100 0]);
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
set(gca,'YTickMode','manual','YTick',[-20,-3]);

%Hanning窗
w_han=hanning(N);
h_han=hdn.*w_han';%FIR滤波器的冲激响应
%对加窗后序列进行DFT
h_han1 = fft(h_han,512);
subplot(3,2,2);
plot(w,20*log10(abs(h_han1(1:256))));
%plot(w,abs(h_han1(1:256)));
title('Hanning');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
%set(gca,'YTickMode','manual','YTick',[-20,-3]);


%hamming窗
w_ham=hamming(N);
h_ham=hdn.*w_ham';
%对加窗后序列进行DFT
h_ham1 = fft(h_ham,512);
subplot(3,2,3);
plot(w,20*log10(abs(h_ham1(1:256))));
title('Hamming');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
set(gca,'YTickMode','manual','YTick',[-20,-3]);

%Bartlett窗
w_bar=bartlett(N);
h_bar=hdn.*w_bar';
%对加窗后序列进行DFT
h_bar1 = fft(h_bar,512);
subplot(3,2,4);
plot(w,20*log10(abs(h_bar1(1:256))));
title('Bartlett三角窗');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');axis([0 1 -100 0]);
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
set(gca,'YTickMode','manual','YTick',[-20,-3]);

%Blackman窗
w_bla=blackman(N);
h_bla=hdn.*w_bla';
%对加窗后序列进行DFT
h_bla1 = fft(h_bla,512);
subplot(3,2,5);
plot(w,20*log10(abs(h_bla1(1:256))));
title('Blackman');
grid;
xlabel('以\pi为单位的频率');
ylabel('对数幅度/dB');
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
set(gca,'YTickMode','manual','YTick',[-20,-3]);

%subplot(326)
figure
plot(w(1:256),20*log10(abs(h_ham1(1:256))));
hold on
plot(w(1:256),20*log10(abs(h_bla1(1:256))));
plot(w(1:256),20*log10(abs(h_rec1(1:256))));
plot(w(1:256),20*log10(abs(h_bar1(1:256))));
plot(w(1:256),20*log10(abs(h_han1(1:256))));
grid;
set(gca,'XTickMode','manual','XTick',[0,0.3,0.5,1]);
set(gca,'YTickMode','manual','YTick',[-20,-3]);
legend('Hamming','Blackman','Rectangle','Triangle','Hanning','Location','best');
legend('boxoff');
hold off