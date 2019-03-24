clear all
close all
clc

% parameters:
a = 2;
b = 3;
theta = [0.05; 0.2; 0.3];
alpha = [-0.1; 0.5; -0.3];
beta = [1.5; -0.3; 0.7];
n = 20;

% For the 3 groups individually:
% optimization:
for split = 1 : 4
    cvx_begin;
        variable T(n);
        expressions s(3, n + 1);
        
        for i = 1 : n
            s(:, i + 1) = (1 - theta) .*  s(:, i) + theta .* (alpha * T(i) + beta * (1 - T(i)));
        end
        
        if split == 4
            maximize min(s(:, n + 1));
            subject to
                T >= 0;
                T <= 1;
                T(1: b) == 1;
                cumsum(1 - T(b + 1: n)) <= a * cumsum(T(b + 1: n));
        else
            maximize s(split, n + 1);
            subject to
                T >= 0;
                T <= 1;
                T(1: b) == 1;
                cumsum(1 - T(b + 1: n)) <= a * cumsum(T(b + 1: n));
        end
    cvx_end;        

    disp(s(:, n + 1));
    
    % plot:
    figure(split)
    subplot(2, 1, 1);
    plot(1 : n, T, "LineWidth", 2);
    xlabel("Lectures");
    ylabel("T");
    title(sprintf("Split %d", split));
    
    subplot(2, 1, 2);
    plot(1 : n + 1, s(1, 1 : n + 1), "LineWidth", 2);
    hold on;
    plot(1 : n + 1, s(2, 1 : n + 1), "LineWidth", 2);
    plot(1 : n + 1, s(3, 1 : n + 1), "LineWidth", 2);
    legend("Group 1", "Group 2", "Group 3");
    xlabel("Lectures");
    ylabel("Emotional State");
end
