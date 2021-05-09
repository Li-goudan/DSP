clc
clear
close all

m = [1 0 0 0 0 1 0 0 1 0 1 1 0 0 1 1 1 1 1 0 0 0 1 1 0 1 1 1 0 1 0];%m���У�����31
n = [1 1 1 1 1 0 1 1 1 0 0 0 1 0 1 0 1 1 0 1 0 0 0 0 1 1 0 0 1 0 0];
L = length(m);

out1 = autocorr(m,L);
out2 = autocorr(n,L);
out3 = crosscorr(m,n,L);

figure
subplot(511)
stem(m,'.');
title('m ���� 1 ');
subplot(512)
stem(n,'.');
title('m ���� 2 ');
subplot(513)
plot(out1);
title('m ���� 1 ������غ���');
subplot(514)
plot(out2);
title('m ���� 2 ������غ���');
subplot(515)
plot(out3);
title('m ���л���غ���');

%����gold����
gold = zeros(31,31);
n1 = n;
for i = 1:L
    n1 = circshift(n1',1)';%��λ
    gold(i,:) = mod(m + n1,2);
end

out1 = autocorr(gold(1,:),L);
out2 = autocorr(gold(2,:),L);
out3 = crosscorr(gold(1,:),gold(2,:),L);

figure
subplot(511)
stem(gold(1,:),'.');
title('gold ���� 1 ');
subplot(512)
stem(gold(2,:),'.');
title('gold ���� 2 ');
subplot(513)
plot(out1);
title('gold ���� 1 ������غ���');
subplot(514)
plot(out2);
title('gold ���� 2 ������غ���');
subplot(515)
plot(out3);
title('gold ���л���غ���');
%%
figure
x=round(rand(1,100));%�������
subplot(311);
stem(x,'.');
title('��Ƶǰ������');
t = (1:3100);%���������
fs = 1/31;
b = rectpulse(x,31);
s = (1-2.*b).*cos(2*pi*fs*t);%����
subplot(312);
plot(s);%��������ͼ��
axis([0,1000,-1.2,1.2]); %���������ֵ
title('����Ƶ BPSK �ѵ��ź�ʱ����');
gold_1 = repmat(gold(1,:),1,100);
gold_2 = mod(gold_1 + b,2);
b1 = rectpulse(gold_2,1);
s1 = (1-2.*b1).*cos(2*pi*fs*t);%����
subplot(313);
plot(s1);%��������ͼ��
axis([0,500,-1.2,1.2]); %���������ֵ
title('��Ƶ BPSK �ѵ��ź�ʱ����');
f1 = fft(b);
f2 = fft(b1);
figure
subplot(211)
plot(fftshift(abs(f1)));
title('����Ƶ�����ź�Ƶ��');
subplot(212)
plot(fftshift(abs(f2)));
title('��Ƶ�����ź�Ƶ��');
%%
SNR = linspace(0,10,21);

for i = 1:21   
    s_0 = awgn(b,SNR(i),'measured');
    s_1 = awgn(b1,SNR(i),'measured');
    
    s_0 = round(s_0);
    s_1 = round(s_1);
%     ind=(s_0>0.5);
%     s_0(ind)=1;
%     s_0(~ind)=0;
%     ind1=(s_1>0.5);
%     s_1(ind1)=1;
%     s_1(~ind1)=0;
    
    error_bit_s(i) = sum(s_0~=b);
    error_bit_s1(i) = sum(s_1~=b1);
    error_rate_s(i) = error_bit_s(i)/3100;
    error_rate_s1(i) = error_bit_s1(i)/3100;
end
error_rate_s = 10*log(error_rate_s);
error_rate_s1 = 10*log(error_rate_s1);
figure
hold on
grid on
z=(0:20)/2;
plot(z,error_rate_s,'-*');
plot(z,error_rate_s1,'-o');
legend('����Ƶ','��Ƶ','Location','best');
title('BER');
xlabel('SNR(dB)');
ylabel('BER(dB)');
%%
function out = autocorr(m,L)
    b=5*L;
    m1=m;
    out=zeros(1,b);
    for i=1:1:b
        out(i)=(sum((1-2*m1).*(1-2*m)))/L;%���� m ������غ���
        m1=circshift(m1',1)';%��λ
    end
end

function out = crosscorr(m,n,L)
    b=5*L;
    m1=m;
    out=zeros(1,b);
    for i=1:1:b
        out(i)=(sum((1-2*m1).*(1-2*n)))/L;%���� m,n �Ļ���غ���
        m1=circshift(m1',1)';%��λ
    end
end