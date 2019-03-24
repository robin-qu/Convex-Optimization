% data for portfolio optimization with qualitative return forecasts
% provides n, l, u, Sigma, sig
clear all;
close all;
clc;

rand('state', 0); 
randn('state', 0); 

n = 10; % number of stocks

c = 0.07 + randn(n,1)*0.1;
r = rand(n,1)*0.2;
r = r';
c = c';
l = c - r;
u = c + r;

Sigma = randn(n);   % capital Sigma
Sigma = 3*eye(n) + Sigma'*Sigma;
Sigma = Sigma/max(diag(Sigma));
Sigma = 0.2^2*Sigma;

sigma_max = sqrt(0.08);   % small sigma


%  r =
% 
%     0.1900
%     0.0462
%     0.1214
%     0.0972
%     0.1783
%     0.1524
%     0.0913
%     0.0037
%     0.1643
%     0.0889
%  c =
% 
%     0.0267
%    -0.0966
%     0.0825
%     0.0988
%    -0.0446
%     0.1891
%     0.1889
%     0.0662
%     0.1027
%     0.0875
    
cvx_begin
    variable x(n)
    maximize c * x - r * abs(x)
    subject to
        sum(x) == 1;
        quad_form(x, Sigma) <= sigma_max * sigma_max;
cvx_end

cvx_begin
    variable x_mid(n)
    maximize c * x_mid
    subject to
        sum(x) == 1;
        quad_form(x, Sigma) <= sigma_max * sigma_max;
cvx_end

disp(c * x_mid)
disp(c * x)
disp(c * x_mid - r * abs(x_mid))
disp(c * x - r * abs(x))