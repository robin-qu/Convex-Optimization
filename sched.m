% Data for minimum energy processor speed scheduling.
clear all;
close all;
clc

n = 12;  % number of jobs.
T = 16;  % number of time periods.

Smin = 1;  % min processor speed.
Smax = 4;  % max processor speed.
R = 1;  % max slew rate.

% Parameters in power/speed model.
alpha = 1;
beta = 1;
gamma = 1;

% Job arrival times and deadlines.
A = [1; 3;  4; 6; 9;  9; 11; 12; 13; 13; 14; 15];
D = [3; 6; 11; 7; 9; 12; 13; 15; 15; 16; 14; 16];
% Total work for each job.
W = [2; 4; 10; 2; 3; 2; 3; 2; 3; 4; 1; 4];

% optimization:
cvx_begin
    variable X(T, n)
    s = X * ones(n, 1);
    minimize sum(alpha + beta * s + gamma * square(s));
    subject to
        Smin <= s <= Smax;
        abs(s(2 : end) - s(1 : end - 1)) <= R;
        X >= 0
        X' * ones(T, 1) >= W;
        for i = 1 : n
            for t = 1 : A(i) - 1
                X(t, i) == 0;
            end
            for t = D(i) + 1 : T
                X(t, i) == 0;
            end
        end
cvx_end


% plot:
figure(1);
theta = X ./ (s * ones(1, n));
bar((s * ones(1, n)) .* theta, 1, 'stacked');
xlabel("Time");
ylabel("Speed");


% Plot showing job availability times & deadlines.
figure(2);
hold on;
scatter(A,[1:n],'k*');
scatter(D+1,[1:n],'ko');
for i=1:n
    plot([A(i),D(i)+1],[i,i],'k-');
end
hold off;
xlabel('time t');
ylabel('job i');

