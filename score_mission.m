function J = score_mission(D, S)


m = 4;
t = 125;    
leaderLambda = 0.5;    
percent = 100;
n = size(D.G, 1);
S = S(:);               
assert(numel(S) <= m, 'S has more than %d leaders.', m);
assert(numel(S) == numel(unique(S)), 'S contains repeated indices.');
assert(all(S >= 1 & S <= n & S == round(S)), 'S contains an invalid robot index.');
assert(~any(ismember(S, D.faulty)), 'S contains a faulty robot.');
e = ones(n, 1);
W = (eye(n) + diag(D.G*e)) \ (eye(n) + D.G);
e_base = mean_sq_dist(D, W, [], t, leaderLambda);
e_new  = mean_sq_dist(D, W, S,  t, leaderLambda);
J = (percent / t) * sum(1 - e_new ./ e_base);
end

function e = mean_sq_dist(D, W, S, T, leaderLambda)
n = size(D.G, 1);
lambda = ones(n, 1);            
lambda(S) = leaderLambda;       
lambda(D.faulty) = 0;          
a = D.P0(:,1);   
b = D.P0(:,2); 
a(S) = D.g(1);  
b(S) = D.g(2); 
X = simulate_anchored(W, lambda, a, D.P0(:,1), T);   
Y = simulate_anchored(W, lambda, b, D.P0(:,2), T);
working = setdiff(1:n, D.faulty);
dx = X(working, 2:end) - D.g(1);   
dy = Y(working, 2:end) - D.g(2);
e = mean(dx.^2 + dy.^2, 1);         
end



