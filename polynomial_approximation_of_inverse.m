clear all
close all
clc

% parameters:
k = 4;
interval1 = [-0.6: 0.01: -0.3]';
interval2 = [0.7 : 0.01: 1.8]';
interval = [interval1; interval2];
power = [1: 1: k];
lambda = interval.^power;

% optimization:
cvx_begin;
    variable c(k);
    minimize(norm(lambda * c - 1, Inf));
cvx_end;