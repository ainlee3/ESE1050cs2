%%Part 2

run('part1.m');
G = G4;

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



error_Ax = norm(A_x(:,end) - W_A^K*x0);
error_Ay = norm(A_y(:,end) - W_A^K*y0);
error_Bx = norm(B_x(:,end) - W_B^K*x0);
error_By = norm(B_y(:,end) - W_B^K*y0);

fprintf('Protocol A x error: %.2e\n', error_Ax);
fprintf('Protocol A y error: %.2e\n', error_Ay);
fprintf('Protocol B x error: %.2e\n', error_Bx);
fprintf('Protocol B y error: %.2e\n', error_By);

%Experiments Section C2:
%Important to Note that the Prediction Log is attached as a separate word
%document rather than written in case study or code comments
%Also I put helper fxn to calculate delta k at bottom of this file instead
%of creating a new one
n = size(G4, 1);
I = eye(n);
C = I - (1/n) * ones(n,n);
%E1
K_max = 5000; %need a k large enough to make sure robots converge, tinkered with
%it a little bit
G4_new = makedisk(P0, rmin+0.4);
G_E1 = {G1, G2, G3, G4, G4_new};
names_E1={'T1 Broadcast', 'T2 Star', 'T3 Ring', 'T4 Disk', "T4 Revised Disk"};
k_epsilon = zeros(5,1);

figure;
hold on;
for t =1:5
    G_curr = G_E1{t};
    d_curr = G_curr * ones(n,1);
    D_curr = diag(d_curr);

    %Protocol A
    W_A_curr = (I + D_curr) \ (I + G_curr);
    A_x = simulate_linear(W_A_curr, x0, K_max);
    A_y = simulate_linear(W_A_curr, y0, K_max);
    
    delta_A = calc_delta_func(A_x, A_y, C);

     k_epsilon(t) = Inf;
    threshold = 0.01 * delta_A(1);

    idx = find(delta_A <= threshold, 1, 'first');

    if ~isempty(idx)
        k_epsilon(t) = idx - 1;
    end

    plot(0:K_max, delta_A, 'DisplayName', names_E1{t});
end
set(gca, 'YScale', 'log');
xlabel('Step k');
ylabel('\delta[k]');
title('Experiment 1: Swarm Spread vs Time for Protocol A');
grid on;
legend('Location','best');
hold off;

% this final bit of code I only need to be able to write down
%values of k_epsilon
disp(' E1 Rendezvous Times');
for t = 1:5
     fprintf('%s: %g steps\n', names_E1{t}, k_epsilon(t));
end

%E2 Code
%Important only need 1-4 here the fifth one not used
for t = 1:4
    G_curr = Gs{t};
    d_curr = G_curr * ones(n,1);
    D_curr = diag(d_curr);
    L_curr = D_curr - G_curr;

    W_A_curr = (I + D_curr) \ (I + G_curr);
    epsilon_curr = 1/max(d_curr);
    W_B_curr = I - epsilon_curr * L_curr;
    A_x = simulate_linear(W_A_curr, x0, K_max);
    B_x = simulate_linear(W_B_curr, x0, K_max);
    A_y = simulate_linear(W_A_curr, y0, K_max);
    B_y = simulate_linear(W_B_curr, y0, K_max);

    actual_A = [A_x(1,K_max +1), A_y(1,K_max +1)];
    actual_B = [B_x(1,K_max +1), B_y(1,K_max +1)];

    %Predicted Calculations based off of checlkpoint c
    v = ones(n,1) + d_curr;
    row_ones = ones(1,n);%need this for summing x0, y0
    sum_v = row_ones * v;
    sum_x0 = row_ones *x0;
    sum_y0 = row_ones * y0;
    predicted_A_x = (v' * x0) / sum_v;
    predicted_A_y= (v' *y0) / sum_v;
    predicted_B_x = sum_x0/n;
    predicted_B_y = sum_y0/n;

fprintf (names{t});
fprintf('Protocol A Predicted: (%.2f, %.2f)  Actual: (%.2f, %.2f)\n', predicted_A_x, predicted_A_y, actual_A(1), actual_A(2));
fprintf('Protocol B Predicted: (%.2f, %.2f)  Actual: (%.2f, %.2f)\n', predicted_B_x, predicted_B_y, actual_B(1), actual_B(2));
end


%Delta Fxn broken down piece by piece, 
function delta = calc_delta_func(X, Y, C)
    [n, num_steps] = size(X);
    delta = zeros(1, num_steps);
    for k =1:num_steps
        x_k = X(:,k);
        y_k = Y(:,k);
        Cx_k = C * x_k;
        Cy_k = C * y_k;
        Norm_x_sq = Cx_k' * Cx_k;
        Norm_y_sq = Cy_k' * Cy_k;
        delta(k) = sqrt(Norm_x_sq + Norm_y_sq);
    end
end
