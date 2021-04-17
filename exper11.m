%% ��ɢʱ��ϵͳ��λ������Ӧ

clc
clear
close all;
a=[5,4,-6];
b=[2,-5,3];

% %xΪ�弤����
% [x,n]=impseq(0,-20,120);
% %�Դ��ݺ����˲�
% h=filter(b,a,x);

%�����˲���������Ӧ
[h,n] = impz(b,a);

figure(1)
%������ɢ��������
stem(n,h,'.');
title('�弤��Ӧ');
xlabel('n');
ylabel('h(n)');

[z,p,g]=tf2zp(b,a);
zplane(z,p)
title('polezero');
%%
% fvtool(b,a,'polezero')
% [b,a] = eqtflength(b,a);
% [z,p,k] = tf2zp(b,a)
%%
function [x,n]=impseq(n0,n1,n2)
n=(n1:n2);
x=((n-n0)==0);
end