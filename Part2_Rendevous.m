
%protocol A
I = eye(n);
d = G*ones(n,1);
D = diag(d);
W_A = (I + D) / (I + G);

%protocol B
L = D - G;
epsilon = 1
W_B = I - epsilon*L;

x0 = P0(:,1);
y0 = P0(:,2);

K = 100;
% Compare protocol trajectories over K iterations
A_x= simulate_linear(W_A,x0,K);
B_x= simulate_linear(W_B,x0,K);

A_y = simulate_linear(W_A,y0,K);
B_y = simulate_linear(W_B,y0,K);

