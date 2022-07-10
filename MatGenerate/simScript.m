clear;clc;close all;

load('data.mat')
load('data2.mat')

a = [data2.time', double(data2.a')];
b = [data2.time', double(data2.b')];

% map = [data.time', data.map'];
map.time = data.time';
map.signals.values = permute(data.map,[2 3 1]);
map.signals.dimensions = [30 40];

sim('simModel.slx')