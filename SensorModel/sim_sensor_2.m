clear;clc;close all;

%%
load('./data.mat');

%%
hz = 3;
time = 0.1:1/hz:length(data.groundtruth)/hz;

error = abs(data.estimate.estAngleMethod1) - abs(data.groundtruth');
win_size = 10;

mu = zeros(1,length(error));
sigma = zeros(1,length(error));

for i = 1:length(error)-win_size
    [muHat,sigmaHat] = normfit(error(i:i+win_size));
    mu(i) = muHat;
    sigma(i) = sigmaHat;
end

x = [data.groundtruth, ones(length(data.groundtruth),1)];
idx = randsample(1:1:length(time),20);

GPR_mu = fitrgp(x(idx,:), mu(idx));
[mu_pred,~,mu_int] = predict(GPR_mu, x);
GPR_sigma = fitrgp(x(idx,:), sigma(idx));
[sigma_pred,~,sigma_int] = predict(GPR_sigma, x);

figure()
ax1=subplot(411);
plot(time,data.groundtruth)
hold on;grid on
plot(time,data.estimate.estAngleMethod1)
ax2=subplot(412);
plot(time,error)
hold on;grid on
ax3=subplot(413);
plot(time,mu)
hold on;grid on
plot(time,mu_pred)
patch([time';flipud(time')],[mu_int(:,1);flipud(mu_int(:,2))],'k','FaceAlpha',0.1);
ax4=subplot(414);
plot(time,sigma)
hold on;grid on
plot(time,sigma_pred)
patch([time';flipud(time')],[sigma_int(:,1);flipud(sigma_int(:,2))],'k','FaceAlpha',0.1);
linkaxes([ax1,ax2,ax3,ax4],'x')

%%
dt = 1/hz;
time_end = time(length(time));

u = [time', data.groundtruth];
x = [time', data.groundtruth];
tau = 1/(2*pi*0.2);
% tau = 0;

saveCompactModel(GPR_mu, 'GPR_mu');
saveCompactModel(GPR_sigma, 'GPR_sigma');

sim('sensor_2.slx')

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
