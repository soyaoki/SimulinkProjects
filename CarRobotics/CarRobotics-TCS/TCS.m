clear all;clc;close all;

%車両パラメータ
m=200; %車体重量
Fz=m*9.81; %垂直荷重
Jm=0.028; %慣性モーメント(モータ)
Jw=0.021; %慣性モーメント(タイヤ)

%タイヤ駆動力モデルの各係数
% K1=0.8883;
% K2=-2.7082;
% K3=3.5188;
% K4=-2.0869;
% K5=0.4536;

%マジックフォーミュラの各係数
K1=6.5;
K2=1.54;
K3=-1;
K4=-4;

%車両寸法パラメータ
lf=0.75; %重心から前輪軸までの距離
lr=0.53; %重心から後輪軸までの距離
l=lf+lr; %ホイールベース
h=0.35; %重心高さ
rw=0.225; %タイヤ有効半径
A=1.528; %面積
n=6.267; %インホイールモータの減速比

%モータのパラメータ
Km=2.0;
tau_m=0.007;
alfa=rw/((Jm*n)+(Jw/n));

%マトリクス
A1=[0 0 alfa; 1 0 0; 0 0 -1/tau_m];
B1=[0;0;Km];

%評価関数の重み
q11=1/(0.1)^2;
q22=1/(0.01)^2;
q33=1/(10)^2;
r11=1/(0.1)^2;
Q=diag([q11 q22 q33]);
R=[r11];

%ゲイン決定
K=lqr(A1,B1,Q,R);
k1=K(1,1);
k2=K(1,2);
k3=K(1,3);

%Simlation
sim('simtcs_V1')
figure
subplot(311)
plot(t.data,vw.data,'b',t.data,vb.data,'r',t.data,vwd.data,'k');
hold on;grid on;
xlabel('Time[s]')
ylabel('Wheel speed/Vehicle speed [m/s]')
subplot(312)
plot(t.data,vw.data-vwd.data)
hold on;grid on;
xlabel('Time[s]')
ylabel('Wheel speed error[m/s]')
subplot(313)
plot(t.data,Tm.data)
hold on;grid on;
xlabel('Time[s]')
ylabel('Motor torque [Nm]')

%伝達関数
num=[alfa*Km*k1 alfa*Km*k2];
den=[tau_m 1+k3 alfa*Km*k1 alfa*Km*k2];
f=logspace(-1,2,1000);
w=2*pi*f;

%周波数応答
[mag,phase]=bode(num,den,w);
figure
subplot(211)
semilogx(f,20*log10(mag));
hold on;grid on;
subplot(212)
semilogx(f,phase);
hold on;grid on;
