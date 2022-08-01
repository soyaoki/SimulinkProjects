%車両パラメータ
m=400;
c=10;
ig=6.267;
rw=0.225;
Kx=40;
tv=0.2;

%ACCパラメータ
Kr=3.0;
Kv=1.5;
Thw=1.0;
R0=2.0;

%モデルフォロイングパラメータ
Kp=10;
Ki=2;

mydt=0.01;
sim('simACC')

figure(1)
subplot(311)
plot(t.data,vp.data,'r',t.data,v.data,'k')
xlabel('Time[s]')
ylabel('Vehicle velocity[m/s]')
grid on;
subplot(312)
plot(t.data,R.data)
xlabel('Time[s]')
ylabel('Intervehicle distance[m]')
grid on;
subplot(313)
plot(t.data,Pa.data)
xlabel('Time[s]')
ylabel('Accelerator pedal input[-]')
grid on;