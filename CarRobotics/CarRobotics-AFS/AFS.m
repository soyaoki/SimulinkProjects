clear;close all;clc;

%% パラメータ
m=400;
iz=159; %Vehicle yaw moment of inertia
lf=0.75;
lr=0.53;
cf=10000;
cr=16000;
n=18.7; %Gear Ratio
l=lf+lr; %Wheel base
v=50/3.6;
K=m/2/l/l*(lr*cr-lf*cf)/cf/cr; %Stability Factor

%状態方程式マトリクス
a11=-2*(cf+cr)/m/v;
a12=-1-2*(lf*cf-lr*cr)/m/v/v;
a21=-2*(lf*cf-lr*cr)/iz;
a22=-2*(lf*lf*cf+lr*lr*cr)/iz/v;
b11=2*cf/m/v;
b12=0;
b21=2*lf*cf/iz;
b22=1/iz;

%Lateral Vehicle Dynamics
a1=2*lf*cr/iz;
a0=4*(lf+lr)*cf*cr/m/iz/v;
b1=2*(cf+cr)/m/v+2*(lf*lf*cf+lr*lr*cr)/iz/v;
b0=4*(lf+lr)^2*cf*cr/m/iz/v/v*(1+K*v*v);
kgamma=a0/b0;
tgamma=a0/b0/a1;
T=0.0106;
mydt=0.01;
G=input('Without Control (0) or With AFS Control (1) : ');
sim('sim_AFS')

if G==1
    color='r';
elseif G==0
    color='k';
end

figure(1)
subplot(311)
plot(t.data,deltaf.data,color);
grid on;hold on;
xlabel('Time[s]')
ylabel('Front steer angle[rad]')
subplot(312)
plot(t.data,beta.data,color);
grid on;hold on;
xlabel('Time[s]')
ylabel('Side slip angle[rad]')
subplot(313)
plot(t.data,gamma.data,color)
grid on;hold on;
xlabel('Time[s]')
ylabel('Yaw rate[rad/s]')