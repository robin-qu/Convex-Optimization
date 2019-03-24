clear all;
close all;
clc;

% parameters:
m = 0.1;
theta = 15 * pi / 180;
T_max = 2
p_init = [0; 0];
p_des = [10; 2];
g = [0; -9.8];
h = 0.1;
A = [-sin(theta), sin(theta);
     cos(theta), cos(theta)];

% optimization:
T0 = 0;
p0 = 0;
lower = 2;
upper = 100;
while lower + 1 < upper
    k = lower + floor((upper -lower) / 2);
    cvx_begin;
        variables T(2, k - 1) p(2, k) v(2, k);
        G = g * ones(1, k - 1);
        F = A * T + m * G;
        minimize 0;
        subject to
            0 <= T <= T_max;
            v(:, 2 : end) == v(:, 1 : end - 1) + h / m * F;
            p(:, 2 : end) == p(:, 1 : end - 1) + h * v(:, 1 : end - 1);
            p(:, 1) == p_init;
            p(:, end) == p_des;
            v(:, 1) == 0;
            v(:, end) == 0;
    cvx_end;
    if cvx_optval == 0
        upper = k;
        T0 = T;
        p0 = p;
    else
        lower = k;
    end
end
k_opt = upper;

% Plot:
figure(1);
plot(p(1, :), p(2, :), "LineWidth", 2);
title("Trajectory");
xlabel("P_1");
ylabel("P_2");

figure(2);
plot(T0(1, :), "LineWidth", 2);
hold on;
plot(T0(2, :), "LineWidth", 2);
xlabel("Time");
ylabel("Tension");
title("Tension versus Time");
legend("T_{left}", "T_{right}");
