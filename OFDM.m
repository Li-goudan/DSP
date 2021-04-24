clc
clear
close all

carrier_count = 10; % ���ز���
symbol_count = 10;% �ܷ�����
ifft_length = 32;% IFFT����

bit_per_symbol = 4; % ���Ʒ�ʽ���� 4PSK��2��/16QAM��4��
% ================�����������=======================
bit_length = carrier_count*symbol_count*bit_per_symbol;
bit_sequence = round(rand(1,bit_length))'; % ������
% ================���ز����Ʒ�ʽ========================
% 1-4���� 5-14��Ч 15-20���� 29-20���� 30-32����
carrier_position = 5:14;
conj_position = 29:-1:20;
bit_moded = qammod(bit_sequence,16,'InputType','bit');
figure('position',[0 0 400 400],'menubar','none');
scatter(real(bit_moded),imag(bit_moded),'filled');
title('���ƺ��ɢ��ͼ');
grid on;
% ===================IFFT===========================
% =================����ת��==========================
ifft_position = zeros(ifft_length,symbol_count);

figure('position',[400 0 400 400],'menubar','none');
stem(abs(bit_moded),'filled');
grid on;
bit_moded = reshape(bit_moded,carrier_count,symbol_count);
ifft_position(carrier_position,:)=bit_moded(:,:);
ifft_position(conj_position,:)=conj(bit_moded(:,:));
signal_time = ifft(ifft_position,ifft_length);

% ===================�����źţ��ྶ�ŵ�====================
signal_Tx = reshape(signal_time,1,[]); % ���ʱ��һ�������źţ�������
mult_path_am = [1 0.2 0.1]; %  �ྶ����
mutt_path_time = [0 20 50]; % �ྶʱ��
windowed_Tx = zeros(size(signal_Tx));
path2 = 0.2*[zeros(1,20) signal_Tx(1:end-20) ];
path3 = 0.1*[zeros(1,50) signal_Tx(1:end-50) ];
signal_Tx_mult = signal_Tx + path2 + path3; % �ྶ�ź�
subplot(2,1,1)
plot(signal_Tx)
title('OFDM�ź�ʱ����')
xlabel('Time/samples')
ylabel('Amplitude')
% =====================�����ź�Ƶ��========================
subplot(2,1,2)
orgin_aver_power = 20*log10(abs(fft(signal_Tx)));
plot(orgin_aver_power)
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['OFDM, numFFT = ' num2str(ifft_length)])
grid on

% ========================��AWGN==========================

Rx_data_sig = awgn(signal_Tx,100,'measured');
Rx_data_mut = awgn(signal_Tx_mult,20,'measured');

figure('menubar','none')
subplot(2,2,1)
plot(Rx_data_sig(1,1:320))
title('����OFDM�ź�ʱ����')
xlabel('Time/samples')
ylabel('Amplitude')
subplot(2,2,2)
after_aver_power = 20*log10(abs(fft(Rx_data_sig)));
plot(after_aver_power)
title('����OFDM�ź�Ƶ��')
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')

subplot(2,2,3)
plot(Rx_data_mut(1,1:320))
title('�ྶOFDM�ź�ʱ����')
xlabel('Time/samples')
ylabel('Amplitude')
subplot(2,2,4)
after_aver_power = 20*log10(abs(fft(Rx_data_mut)));
plot(after_aver_power)
title('�ྶOFDM�ź�Ƶ��')
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')

% =======================����ת��==========================
Rx_data_sig = reshape(Rx_data_sig,ifft_length,[]);
Rx_data_mut = reshape(Rx_data_mut,ifft_length,[]);

% =========================FFT=============================
fft_sig = fft(Rx_data_sig);
fft_mut = fft(Rx_data_mut);
% =========================������===========================
data_sig = fft_sig(carrier_position,:);
data_mut = fft_mut(carrier_position,:);
figure
scatter(real(reshape(data_sig,1,[])),imag(reshape(data_sig,1,[])),'.')
grid on;
figure
scatter(real(reshape(data_mut,1,[])),imag(reshape(data_mut,1,[])),'.')
grid on;

% ======================����������=========================
SNR = linspace(1,30,300);

for i = 1:300
    Rx_data_sig = awgn(signal_Tx,SNR(i),'measured');
    Rx_data_mut = awgn(signal_Tx_mult,SNR(i),'measured');
    
    Rx_data_sig = reshape(Rx_data_sig,ifft_length,[]);
    Rx_data_mut = reshape(Rx_data_mut,ifft_length,[]);
    
    % =========================FFT=============================
    fft_sig = fft(Rx_data_sig);
    fft_mut = fft(Rx_data_mut);
    % =========================������===========================
    data_sig = fft_sig(carrier_position,:);
    data_mut = fft_mut(carrier_position,:);
    
    % =========================��ӳ��===========================
    bit_demod_sig = reshape(qamdemod(data_sig,16,'OutputType','bit'),[],1);
    bit_demod_mut = reshape(qamdemod(data_mut,16,'OutputType','bit'),[],1);
    
    % =========================������===========================
    error_bit_sig = sum(bit_demod_sig~=bit_sequence);
    error_bit_mut = sum(bit_demod_mut~=bit_sequence);
    error_rate_sig(i) = error_bit_sig/bit_length;
    error_rate_mut(i) = error_bit_mut/bit_length;
end

x = (1:300)/10;
subplot(2,1,1)
plot(x,error_rate_sig)%��������������
title('����OFDMϵͳ������')
xlabel('SNR(dB)');
ylabel('error_rate(%)')
subplot(2,1,2)
plot(x,error_rate_mut)%�ྶ����������
title('�ྶOFDMϵͳ������')
xlabel('SNR(dB)');
ylabel('error_rate(%)')
%%