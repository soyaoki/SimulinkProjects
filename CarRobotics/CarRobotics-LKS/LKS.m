clear;close all;clc;

%% パラメータ
m=420;
iz=159; %Vehicle yaw moment of inertia
lf=0.75;
lr=0.53;
cf=10000;
cr=16000;
n=18.7; %Gear Ratio
l=lf+lr; %Wheel base
vkm=50;
v=vkm/3.6;
L=6.31; %Preview distance
dv=0.814; %Tread
d=0.5; %Roal width
rw=0.225; %Wheel radius
tp=L/v; %Preview time
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

%モデルマッチング
hm1=1/iz;
hmo=2*(cf+cr)/m/iz/v;
g1=2*(cf+cr)/m/v+2*(lf*lf*cf+lr*lr*cr)/iz/v;
go=4*l*l*cf*cr/m/iz/v/v-2*(lf*cf-lr*cr)/iz;

%simulation
mydt=0.01;
sim('LKS_1')

figure(1)
subplot(311)
plot(t.data,ysr.data);
grid on;
xlabel('Time[s]')
ylabel('Preview lateral deviation[m]')
subplot(312)
plot(t.data,gammad.data,'r',t.data,gamma.data);
grid on;
xlabel('Time[s]')
ylabel('Yaw rate[rad/s]')
subplot(313)
plot(t.data,dyc.data)
grid on;
xlabel('Time[s]')
ylabel('Yaw moment input[Nm]')