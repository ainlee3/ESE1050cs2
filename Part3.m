%% Part III setup: one practice deployment, no leaders
D = make_deployment(7);                
n = size(D.G, 1);                      
e = ones(n, 1);
W = (eye(n) + diag(D.G*e)) \ (eye(n) + D.G);    

S = [];                                
lambda = ones(n, 1);
lambda(S) = 0.5;
lambda(D.faulty) = 0;

a = D.P0(:,1);   
a(S) = D.g(1);         
b = D.P0(:,2);   
b(S) = D.g(2); 

x0=D.P0(:,1);
y0=D.P0(:,2);


K = 20000;

Lambda = diag(lambda);

M = eye(n) - Lambda*W;

xstar = M \ ((eye(n) - Lambda)*a);      
ystar = M \ ((eye(n) - Lambda)*b);     
X = simulate_anchored(W, lambda, a, x0, K);
Y = simulate_anchored(W, lambda, b, y0, K);

norm(X(:,end) - xstar)                             
norm(xstar - (Lambda*W*xstar + (eye(n)-Lambda)*a))  
norm(Y(:,end) - ystar)                                     
norm(ystar - (Lambda*W*ystar + (eye(n)-Lambda)*b))         