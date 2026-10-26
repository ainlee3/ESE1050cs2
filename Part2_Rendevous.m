
n = size(G,1);
I = eye(n);
d = G*ones(n,1);
D = diag(d);
L = D - G;

%protocol A
W_A = (I + D) \ (I + G);

%protocol B
epsilon = 1 / max(d);
W_B = I - epsilon*L;

% simulate

K = 100;

x0 = P0(:,1);
y0 = P0(:,2);

A_x= simulate_linear(W_A,x0,K);
B_x= simulate_linear(W_B,x0,K);

A_y = simulate_linear(W_A,y0,K);
B_y = simulate_linear(W_B,y0,K);


error_A = norm(A_x(:,end) - W_A^K*x0);
error_B = norm(B_x(:,end) - W_B^K*x0);

fprintf('Protocol A error: %.2e\n', error_A);
fprintf('Protocol B error: %.2e\n', error_B);
