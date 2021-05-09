%·�����-Ƶ������ͼ
clc
clear
close all

fc=(300:100:1500);%��λ:MHz
d=[2;2;2;5;5;5];%��λ:km
ht=30;%��λ:m
hr=1.5;%��λ:m
a_hr=3.2*(log10(11.75*hr)).^2-4.97;%��λ:m
Ccell_city=zeros(1,length(fc));
Ccell_suburban=(-2)*(log10(fc/28)).^2-5.4;
Ccell_country=-4.78*(log10(fc)).^2+18.33*log10(fc)-40.98;
Ccell=[Ccell_city;Ccell_suburban;Ccell_country;Ccell_city;Ccell_suburban;Ccell_country];
Cterrain=0;

Lp=69.55+26.16*log10(fc)-13.82*log10(ht)-a_hr+(44.9-6.55*log10(ht))*log10(d)+Ccell+Cterrain;

figure;
grid on;
hold on;
plot(fc,Lp(1,:),'b-o');
plot(fc,Lp(4,:),'b:o');
plot(fc,Lp(2,:),'b-*');
plot(fc,Lp(5,:),'b:*');
plot(fc,Lp(3,:),'b-s');
plot(fc,Lp(6,:),'b:s');
legend('���� d=2km','���� d=5km','���� d=2km','���� d=5km','��� d=2km','��� d=5km','Location','best');

xlabel('Ƶ��(MHz)');
ylabel('�����ֵ(dB)');
%%
%·�����-��������ͼ
clc
clear
close all

fc=[600,1500];
d=(1:1:20);
ht=30;%��λ:m
hr=1.5;%��λ:m
a_hr=3.2*(log10(11.75*hr)).^2-4.97;%��λ:m
Ccell_city=zeros(1,length(fc));
Ccell_suburban=(-2)*(log10(fc/28)).^2-5.4;
Ccell_country=-4.78*(log10(fc)).^2+18.33*log10(fc)-40.98;
Ccell=[Ccell_city;Ccell_suburban;Ccell_country];
Ccell=[Ccell(:,1);Ccell(:,2)];
Cterrain=0;
fc1=[600;600;600;1500;1500;1500];

Lp=69.55+26.16*log10(fc1)-13.82*log10(ht)-a_hr+(44.9-6.55*log10(ht))*log10(d)+Ccell+Cterrain;

figure;
grid on;
hold on;
plot(d,Lp(1,:),'b-o');
plot(d,Lp(4,:),'b:o');
plot(d,Lp(2,:),'b-*');
plot(d,Lp(5,:),'b:*');
plot(d,Lp(3,:),'b-s');
plot(d,Lp(6,:),'b:s');
legend('���� fc=300MHz','���� fc=1500MHz','���� fc=300MHz','���� fc=1500MHz','��� fc=300MHz','��� fc=1500MHz','Location','best');

xlabel('����(km)');
ylabel('�����ֵ(dB)');