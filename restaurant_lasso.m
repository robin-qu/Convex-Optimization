clear all
close all
clc

% loading data
load('restaurant_reviews.mat');
y = y';

% define parameters
n = size(X, 1);
m = size(X, 2);
lam0 = 2.5;
r = 0.93;
k = 0 : 5;
lambda = lam0 * r .^ k;

% (i)
[w0, theta0] = lasso(X, y, lam0); 
ratio1 = zeros(5, 1); 
for i = 1 : 5
    w_t = w0; 
    theta_t = (lambda(i + 1) / lam0) * theta0;  
    w_new1 = screen(X, m, y, theta_t, w_t, lambda(i + 1));
    if i==1 
        temp=w_new1; 
    end
    ratio1(i) = sum(w_new1) / m;
end 
figure(1)
plot(1 : 5, ratio1, 'LineWidth', 1.5);
axis([1 5 0 1]);
xlabel('k');
ylabel('Screen Ratio');
title('(i)');

% (ii)
ratio2 = zeros(5, 1); 
for i = 1 : 5    
    [w_old , theta_old] = lasso(X, y, lambda(i)); 
    w_t = w_old; 
    theta_t = (lambda(i+1) / lambda(i)) * theta_old; 
    w_new2 = screen(X, m, y, theta_t, w_t, lambda(i + 1));
    ratio2(i) = sum(w_new2) / m;
end
figure(2)
plot(1 : 5, ratio2, 'LineWidth', 1.5);
axis([1 5 0 1]);
xlabel('k');
ylabel('Screen Ratio');
title('(ii)');

% (iii)
lam1 = lam0 * r;
tic;
[w_c1, theta_c1] = lasso(X, y, lam1);
stop = toc
F1 = F(X, y, w_c1, lam1)
features1 = feature_names(w_c1 > 0.001, :);

w_t = w0; 
theta_t = (lam1 / lam0) * theta0;
w_screened = screen(X, m, y, theta_t, w_t, lam1);
subX = X(:, w_screened == 0);
tic;
[w_c2, theta_c2] = lasso(subX, y, lam1);
stop = toc
F2 = F(subX, y, w_c2, lam1)
features2 = feature_names(w_c2 > 0.001, :);

function [w, theta] = lasso(X, y, lam) 
    cvx_begin quiet
        variable v(size(X,2)); 
        minimize(0.5 * sum_square_abs(X * v - y) + lam * sum(v)); 
        subject to 
            v >= 0; 
    cvx_end
    w = v; 
    theta = X * v - y; 
end

function [res] = F(X, y, w, lambda) 
    res = 0.5 * norm(X * w - y, 2)^2 + lambda * norm(w, 1);
end

function [res] = G(theta, y)
    res = y' * theta + 0.5 * norm(theta, 2)^2;
end

function [w_new] = screen(X, m, y, theta, w, lam)
    w_new = zeros(m, 1);
    for j = 1 : m 
        if -X(:, j)' * theta + norm(X(:, j), 2) * sqrt(2 * (F(X, y, w, lam) + G(theta, y))) < lam 
            w_new(j) = 1;
        end
    end
end
