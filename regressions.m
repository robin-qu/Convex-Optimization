clear all
close all
clc

n = 4
m = 2
lam = 1
X = [1, 2; 4, -5; -7, 8; -9, 11];
Y = [1; 3; 2; 7];

%% Part(a)
cvx_begin;
    variable b(m);
    variable g;
    minimize(square_pos(norm(Y - X * b - g * ones(n, 1), 2)));
cvx_end;

%% Part(b)
cvx_begin;
    variable b(m);
    variable g;
    minimize(square_pos(norm(Y - X * b - g * ones(n, 1), 2)));
    b >= 0;
cvx_end;

%% Part(c)
cvx_begin;
    variable b(m);
    variable g;
    minimize(square_pos(norm(Y - X * b - g * ones(n, 1), 2)) + norm(b, 1));
cvx_end;

%% Part(d)
cvx_begin;
    variable b(m);
    variable g;
    minimize(sum(1/2 * huber(Y - X * b - g * ones(n, 1), 1/2)));
cvx_end;
