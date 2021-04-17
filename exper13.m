%% ��ɢ���

clc
clear
close all

[u1,n] = stepseq(0,-5,50);
u2 = stepseq(10,-5,50);

%input
x = u1 - u2;
%ϵͳ����
h = (0.9.^n) .* u1;
%��ɢ���output
y = conv(x,h);

%��ͼ
subplot(3,1,1);
stem(n,x,'filled');
title('��������');
xlabel('n');
ylabel('x(n)');
%����������ķ�Χ
axis([-5 50 0 1.5]);

subplot(3,1,2);
stem(n,h,'filled');
title('�����Ӧ����');
xlabel('n');
ylabel('h(n)');
axis([-5 50 0 1.5]);

subplot(3,1,3);
%��ɢ����ĳ���Ϊ���߳��Ⱥ�-1
n1 = (n(1)+n(1):n(length(x))+n(length(h)));
stem(n1,y,'filled');
title('�����Ӧ');
xlabel('n');
ylabel('y(n)');
axis([-5,50,0,7]);


%%
function[x,n]=stepseq(n0,n1,n2)
n=(n1:n2);
x=((n-n0)>=0);
end
%��ɢ��Ծ����