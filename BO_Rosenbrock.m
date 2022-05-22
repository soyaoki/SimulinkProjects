clear;clc;close all;

%% Mathwork's example
% load ionosphere
% rng default
% num = optimizableVariable('n',[1,30],'Type','integer');
% dst = optimizableVariable('dst',{'chebychev','euclidean','minkowski'},'Type','categorical');
% c = cvpartition(351,'Kfold',5);
% fun = @(x)kfoldLoss(fitcknn(X,Y,'CVPartition',c,'NumNeighbors',x.n,...
%     'Distance',char(x.dst),'NSMethod','exhaustive'));
% results = bayesopt(fun,[num,dst],'Verbose',0,...
%     'AcquisitionFunctionName','expected-improvement-plus')

%% example
X1=0; X2=0;

x1 = optimizableVariable('x1',[-5,5],'Type','integer');
x2 = optimizableVariable('x2',[-5,5],'Type','integer');

fun = @(x)simulation_in_Simulink(x.x1, x.x2);
resbo = bayesopt(fun, [x1,x2],'Verbose',0,...
    'AcquisitionFunctionName','expected-improvement-plus')