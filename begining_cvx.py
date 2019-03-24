# ME578 Convex Optimization
# Professor Maryam Fazel
# Homework 4.3
# Hongbin Qu

import numpy as np
import cvxpy as cp

# Create variables:
n = 4
m = 2
lam = 1
X = np.array([[1, 2], [4, -5], [-7, 8], [-9, 11]])
Y = np.array([1, 3, 2, 7]).T
beta = cp.Variable(m)
gamma = cp.Variable()

### Part (a) ###
objective1 = cp.Minimize(cp.sum_squares(Y - X * beta - gamma * np.ones(n)))
prob1 = cp.Problem(objective1)
print('Part (a):')
print('Optimal value:', prob1.solve())
print('Optimal beta:', beta.value)
print('Optimal gamma:', gamma.value)
print()

### Part (b) ###
objective2 = cp.Minimize(cp.sum_squares(Y - X * beta - gamma * np.ones(n)))
constrains2 = [beta >= 0]
prob2 = cp.Problem(objective2, constrains2)
print('Part (b):')
print('Optimal value:', prob2.solve())
print('Optimal beta:', beta.value)
print('Optimal gamma:', gamma.value)
print()

### Part (c) ###
objective3 = cp.Minimize(cp.sum_squares(Y - X * beta - gamma * np.ones(n)) + 
                         lam * cp.norm(beta, 1))
prob3 = cp.Problem(objective3)
print('Part (c):')
print('Optimal value:', prob3.solve())
print('Optimal beta:', beta.value)
print('Optimal gamma:', gamma.value)
print()

### Part (d) ###
objective4 = cp.Minimize(cp.sum(cp.huber(Y - X * beta - gamma * np.ones(n),
                                         0.5)))
prob4 = cp.Problem(objective4)
print('Part (d):')
print('Optimal value:', prob4.solve())
print('Optimal beta:', beta.value)
print('Optimal gamma:', gamma.value)
print()
