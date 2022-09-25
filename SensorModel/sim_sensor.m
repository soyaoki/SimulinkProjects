clear;clc;close all;

%%
load('./data.mat');

%%
hz = 3;
dt = 1/hz;
time = 0.1:1/hz:length(data.groundtruth)/hz;
time_end = time(length(time));

u = [time', data.groundtruth];
x = [time', data.groundtruth];

tau = 1/(2*pi*0.2);

sim('sensor.slx')

%%
figure()
plot(u(:,1),u(:,2))
hold on
plot(y)
plot(time, data.estimate.estAngleMethod1)
legend('groundtruth','method1(sensormodel)','method1')

%%
condition1 = (abs(data.groundtruth)<15);
condition2 = logical((abs(data.groundtruth)>=15) .* (abs(data.groundtruth)<30));
condition3 = (abs(data.groundtruth)>=30);

figure()
scatter(find(condition1), data.groundtruth(condition1))
hold on; grid on
scatter(find(condition2), data.groundtruth(condition2))
scatter(find(condition3), data.groundtruth(condition3))
ylabel('Sensing Value (conditional)')

%% Method1
error = abs(data.estimate.estAngleMethod1) - abs(data.groundtruth)';

figure('Name','Method1 Real-data')
ax1=subplot(221);
plot(data.groundtruth)
hold on; grid on
plot(data.estimate.estAngleMethod1)
ylabel('Sensing Value')
ax2=subplot(222);
scatter(find(condition1), error(condition1))
hold on; grid on
scatter(find(condition2), error(condition2))
scatter(find(condition3), error(condition3))
ylabel('Abs error')
ax3=subplot(223);
bar([mean(error(condition1)),mean(error(condition2)),mean(error(condition3))])
ylabel('Mean e')
ax4=subplot(224);
bar([std(error(condition1)),std(error(condition2)),std(error(condition3))])
ylabel('Std e')
linkaxes([ax1,ax2],'x')

figure('Name','Method1 Real-data')
histogram(diff(error),'Normalization', 'pdf')

%% Synthetic Method1
error = abs(y.Data) - abs(data.groundtruth);

[muHat1,sigmaHat1] = normfit(error(condition1));
[muHat2,sigmaHat2] = normfit(error(condition2));
[muHat3,sigmaHat3] = normfit(error(condition3));

figure('Name','Synthetic by sensor model (Normal distribution)')
ax1=subplot(131);
histogram(error(condition1),'Normalization', 'pdf')
hold on; grid on
plot([-5:0.1:5], normpdf([-5:0.1:5], muHat1, sigmaHat1))
title(strcat('muHat1=', string(muHat1), ', sigmaHat1=', string(sigmaHat1)))
ax2=subplot(132);
histogram(error(condition2),'Normalization', 'pdf')
hold on; grid on
plot([-5:0.1:5], normpdf([-5:0.1:5], muHat2, sigmaHat2))
title(strcat('muHat2=', string(muHat2), ', sigmaHat2=', string(sigmaHat2)))
ax3=subplot(133);
histogram(error(condition3),'Normalization', 'pdf')
hold on; grid on
plot([-5:0.1:5], normpdf([-5:0.1:5], muHat3, sigmaHat3))
title(strcat('muHat3=', string(muHat3), ', sigmaHat3=', string(sigmaHat3)))

figure('Name','Synthetic by sensor model (Normal distribution)')
ax1=subplot(221);
plot(time,data.groundtruth)
hold on; grid on
plot(time,data.estimate.estAngleMethod1)
plot(y)
legend('groundtruth','method1','method1(sensormodel)')
ylabel('Sensing Value')
ax2=subplot(222);
scatter(time(condition1), error(condition1))
hold on; grid on
scatter(time(condition2), error(condition2))
scatter(time(condition3), error(condition3))
ylabel('Abs error')
ax3=subplot(223);
bar([mean(error(condition1)),mean(error(condition2)),mean(error(condition3))])
ylabel('Mean e')
ax4=subplot(224);
bar([std(error(condition1)),std(error(condition2)),std(error(condition3))])
ylabel('Std e')
linkaxes([ax1,ax2],'x')

figure('Name','Synthetic by sensor model (Normal distribution)')
histogram(diff(error),'Normalization', 'pdf')

%% GPR
GPR = fitrgp(data.groundtruth, data.estimate.estAngleMethod1);
% GPR = fitrgp(data.groundtruth(1:length(time)/2), data.estimate.estAngleMethod1(1:length(time)/2));
[ypred,~,yint] = predict(GPR, data.groundtruth);

error = abs(ypred) - abs(data.groundtruth);

figure('Name','GPR')
ax1=subplot(221);
plot(time,data.groundtruth)
hold on; grid on
plot(time,data.estimate.estAngleMethod1)
plot(time,ypred)
patch([time';flipud(time')],[yint(:,1);flipud(yint(:,2))],'k','FaceAlpha',0.1);
legend('groundtruth','method1','method1(GPR)')
ylabel('Sensing Value')
ax2=subplot(222);
scatter(time(condition1), error(condition1))
hold on; grid on
scatter(time(condition2), error(condition2))
scatter(time(condition3), error(condition3))
ylabel('Abs error')
ax3=subplot(223);
bar([mean(error(condition1)),mean(error(condition2)),mean(error(condition3))])
ylabel('Mean e')
ax4=subplot(224);
bar([std(error(condition1)),std(error(condition2)),std(error(condition3))])
ylabel('Std e')
linkaxes([ax1,ax2],'x')
