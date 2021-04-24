clc
clear
close all

carrier_count = 10; % 子载波数
symbol_count = 10;% 总符号数
ifft_length = 32;% IFFT长度

bit_per_symbol = 4; % 调制方式决定 4PSK（2）/16QAM（4）
% ================产生随机序列=======================
bit_length = carrier_count*symbol_count*bit_per_symbol;
bit_sequence = round(rand(1,bit_length))'; % 列向量
% ================子载波调制方式========================
% 1-4置零 5-14有效 15-20置零 29-20共轭 30-32置零
carrier_position = 5:14;
conj_position = 29:-1:20;
bit_moded = qammod(bit_sequence,16,'InputType','bit');
figure('position',[0 0 400 400],'menubar','none');
scatter(real(bit_moded),imag(bit_moded),'filled');
title('调制后的散点图');
grid on;
% ===================IFFT===========================
% =================串并转换==========================
ifft_position = zeros(ifft_length,symbol_count);

figure('position',[400 0 400 400],'menubar','none');
stem(abs(bit_moded),'filled');
grid on;
bit_moded = reshape(bit_moded,carrier_count,symbol_count);
ifft_position(carrier_position,:)=bit_moded(:,:);
ifft_position(conj_position,:)=conj(bit_moded(:,:));
signal_time = ifft(ifft_position,ifft_length);

% ===================发送信号，多径信道====================
signal_Tx = reshape(signal_time,1,[]); % 变成时域一个完整信号，待传输
mult_path_am = [1 0.2 0.1]; %  多径幅度
mutt_path_time = [0 20 50]; % 多径时延
windowed_Tx = zeros(size(signal_Tx));
path2 = 0.2*[zeros(1,20) signal_Tx(1:end-20) ];
path3 = 0.1*[zeros(1,50) signal_Tx(1:end-50) ];
signal_Tx_mult = signal_Tx + path2 + path3; % 多径信号
subplot(2,1,1)
plot(signal_Tx)
title('OFDM信号时域波形')
xlabel('Time/samples')
ylabel('Amplitude')
% =====================发送信号频谱========================
subplot(2,1,2)
orgin_aver_power = 20*log10(abs(fft(signal_Tx)));
plot(orgin_aver_power)
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['OFDM, numFFT = ' num2str(ifft_length)])
grid on

% ========================加AWGN==========================

Rx_data_sig = awgn(signal_Tx,100,'measured');
Rx_data_mut = awgn(signal_Tx_mult,20,'measured');

figure('menubar','none')
subplot(2,2,1)
plot(Rx_data_sig(1,1:320))
title('单径OFDM信号时域波形')
xlabel('Time/samples')
ylabel('Amplitude')
subplot(2,2,2)
after_aver_power = 20*log10(abs(fft(Rx_data_sig)));
plot(after_aver_power)
title('单径OFDM信号频谱')
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')

subplot(2,2,3)
plot(Rx_data_mut(1,1:320))
title('多径OFDM信号时域波形')
xlabel('Time/samples')
ylabel('Amplitude')
subplot(2,2,4)
after_aver_power = 20*log10(abs(fft(Rx_data_mut)));
plot(after_aver_power)
title('多径OFDM信号频谱')
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')

% =======================串并转换==========================
Rx_data_sig = reshape(Rx_data_sig,ifft_length,[]);
Rx_data_mut = reshape(Rx_data_mut,ifft_length,[]);

% =========================FFT=============================
fft_sig = fft(Rx_data_sig);
fft_mut = fft(Rx_data_mut);
% =========================降采样===========================
data_sig = fft_sig(carrier_position,:);
data_mut = fft_mut(carrier_position,:);
figure
scatter(real(reshape(data_sig,1,[])),imag(reshape(data_sig,1,[])),'.')
grid on;
figure
scatter(real(reshape(data_mut,1,[])),imag(reshape(data_mut,1,[])),'.')
grid on;

% ======================误码率曲线=========================
SNR = linspace(1,30,300);

for i = 1:300
    Rx_data_sig = awgn(signal_Tx,SNR(i),'measured');
    Rx_data_mut = awgn(signal_Tx_mult,SNR(i),'measured');
    
    Rx_data_sig = reshape(Rx_data_sig,ifft_length,[]);
    Rx_data_mut = reshape(Rx_data_mut,ifft_length,[]);
    
    % =========================FFT=============================
    fft_sig = fft(Rx_data_sig);
    fft_mut = fft(Rx_data_mut);
    % =========================降采样===========================
    data_sig = fft_sig(carrier_position,:);
    data_mut = fft_mut(carrier_position,:);
    
    % =========================逆映射===========================
    bit_demod_sig = reshape(qamdemod(data_sig,16,'OutputType','bit'),[],1);
    bit_demod_mut = reshape(qamdemod(data_mut,16,'OutputType','bit'),[],1);
    
    % =========================误码率===========================
    error_bit_sig = sum(bit_demod_sig~=bit_sequence);
    error_bit_mut = sum(bit_demod_mut~=bit_sequence);
    error_rate_sig(i) = error_bit_sig/bit_length;
    error_rate_mut(i) = error_bit_mut/bit_length;
end

x = (1:300)/10;
subplot(2,1,1)
plot(x,error_rate_sig)%单径误码率曲线
title('单径OFDM系统误码率')
xlabel('SNR(dB)');
ylabel('error_rate(%)')
subplot(2,1,2)
plot(x,error_rate_mut)%多径误码率曲线
title('多径OFDM系统误码率')
xlabel('SNR(dB)');
ylabel('error_rate(%)')
%%