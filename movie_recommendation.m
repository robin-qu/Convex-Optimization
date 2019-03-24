clear all
close all
clc

load('matrix_completion_data.mat');
size = size(X);
n = size(1);
m = size(2);

cvx_begin
    variables W1(m, m) W2(n, n) Xpredict(m, n);
    expressions A(m + n, m + n);
    A = [W1, Xpredict; Xpredict', W2];
    minimize trace(W1) / 2 + trace(W2) / 2
    subject to
         A == semidefinite (m + n);
cvx_end

error = sum(sum(abs(Xpredict - Xtrue))) / sum(sum(abs(Xtrue)));