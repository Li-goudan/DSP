%% ��ɢ�������ͼ��

clc
clear
close all

n=(-10:10);
%x(n)����
x=zeros(1,length(n));
x((find((n>=0)&(n<=4))))=1;
%h(n)����
h=zeros(1,length(n));
h((find((n>=0)&(n<=5))))=0.5;
%����x(n)
subplot(3,2,1);
stem(n,x,'*');
%����h(n)
subplot(3,2,3);
stem(n,h,'.');

%����������ƴ�ֱ��������ҷ�ת
%n1=fliplr(-n);
h1=fliplr(h);
subplot(3,2,5);
stem(n,x,'*');
hold on;
stem(n,h1,'.');
%������չ
h2=[0,h1];
h2(length(h2))=[];
%n2=n1;

subplot(3,2,2);
stem(n,x,'*');
hold on;
stem(n,h2,'.');
h3=[0,h2];
h3(length(h3))=[];
%n3=n2;

subplot(3,2,4);
stem(n,x,'*');
hold on;
stem(n,h3,'.');
n4=-n;
nmin=min(n)-max(n4);
nmax=max(n)-min(n4);
n=nmin:nmax;
y=conv(x,h);
%������
subplot(3,2,6);
stem(n,y,'.');