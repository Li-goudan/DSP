%% ���ǲ��ͷ����ǲ��Ƚ�

clc
clear 
close all

N = 8;
n = [0:N-1];

%�������ǲ�����
i = 0:3;
xc(i+1) = i+1;
i = 4:7;
xc(i+1) = 8-i;
%���巴���ǲ�����
j = 0:3;
xd(j+1) = 4-j;
j = 4:7;
xd(j+1) = j-3;

%hcΪxc��DFT
hc=fft(xc,N);
%hdΪxd��DFT
hd=fft(xd,N);

%��ͼ
subplot(221);
stem(n,xc,'filled');
xlabel('n');
ylabel('Xc(n)');
title('���ǲ�����');
subplot(222);
stem(n,xd,'filled');
xlabel('n');
ylabel('Xd(n)');
title('�����ǲ�����');
subplot(223);
stem(n,abs(hc),'filled');
xlabel('k');
ylabel('Xc(k)');
title('���ǲ���Ƶͼ');
subplot(224);
stem(n,abs(hd),'filled');
xlabel('k');
ylabel('Xd(k)');
title('�����ǲ�Ƶ��ͼ');