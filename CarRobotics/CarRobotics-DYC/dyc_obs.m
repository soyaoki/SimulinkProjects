clear;close all;clc;

%% パラメータ
m=400;
iz=159;
lf=0.75;
lr=0.53;
cf=10000;
cr=16000;
n=18.7;
l=lf+lr;
v=50/3.6;

%状態方程式マトリクス
a11=-2*(cf+cr)/m/v;
a12=-1-2*(lf*cf-lr*cr)/m/v/v;
a21=-2*(lf*cf-lr*cr)/iz;
a22=-2*(lf*lf*cf+lr*lr*cr)/iz/v;
b11=2*cf/m/v;
b12=0;
b21=2*lf*cf/iz;
b22=1/iz;

%F/B gain
Kff=(a22*b11-a12*b21)/(a12*b22*n);

%Observer gain
%L1=10;L2=425;
L1=-(a11*(-a11-30)-(15*15+10*10-a21*a12))/a21;L2=a11+a22-(-30);
eig([a11 a21-L1;a21 a22-L2])

%Desired model
kbeta=0;
tbeta=0.05;
kgamma=-b11/a12/n;
tgamma=0.05;

A=[a11 a12;a21 a22];
B=[b12;b22];
Q=diag([10000 10]);
R=1;
Kfb=lqr(A,B,Q,R);
Kb=Kfb(1,1);
Kg=Kfb(1,2);

%simulation
G=input('Without Control (0) or With DYC Control (1) : ');
mydt=0.01;
sim('DYC_obs')

K=menu('Choose a color','RED','BLACK','BLUE','MAGENTA','YELLOW','GREEEN');
if K==1
    color='r';
elseif K==2
    color='k';
elseif K==3
    color='b';
elseif K==4
    color='m';
elseif K==5
    color='y';
elseif K==6
    color='g';
end

figure(1)
subplot(411)
plot(t.data,deltaf.data,color);
hold on;grid on;
xlabel('Time[s]')
ylabel('Steer angle[rad]')
subplot(412)
plot(t.data,beta.data,color);
hold on;grid on;
xlabel('Time[s]')
ylabel('Side slip angle[deg]')
subplot(413)
plot(t.data,gamma.data,color)
hold on;grid on;
xlabel('Time[s]')
ylabel('Yaw rate[deg/s]')
subplot(414)
plot(t.data,M.data,color);
hold on;grid on;
xlabel('Time[s]')
ylabel('Yaw control moment[Nm]')

% figure(2)
% plot(t.data,gamma.data)
% hold on
% plot(t.data,gamma1.data)
% hold on
% plot(t.data,gamma2.data)
