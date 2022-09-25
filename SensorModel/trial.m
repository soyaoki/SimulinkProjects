clear;clc;close all;

%%
load('./data.mat');

figure()
ax1=subplot(211);
plot(data.groundtruth)
hold on; grid on
plot(data.estimate.estAngleMethod1)
plot(data.estimate.estAngleMethod2)
plot(data.estimate.estAngleMethod3)
ylabel('Sensing Value')
ax2=subplot(212);
plot(data.groundtruth - data.groundtruth)
hold on; grid on
plot(data.estimate.estAngleMethod1 - data.groundtruth')
plot(data.estimate.estAngleMethod2 - data.groundtruth')
plot(data.estimate.estAngleMethod3 - data.groundtruth')
ylabel('Error')
linkaxes([ax1,ax2],'x')

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

figure()
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