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
b21=2*lf*cf/iz;

%simulation
mydt=0.01;
sim('sim_wocon')

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
subplot(211)
plot(t.data,beta.data,color);
hold on;grid on;
xlabel('Time[s]')
ylabel('Side slip angle[deg]')
subplot(212)
plot(t.data,gamma.data,color)
hold on;grid on;
xlabel('Time[s]')
ylabel('Yaw rate[deg/s]')
