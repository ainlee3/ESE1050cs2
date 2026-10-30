function X = simulateAnchored(W, lambda, a, x0, K)
n = length(x0);
X = zeros(n, K+1);
I = eye(n);
Lambda = diag(lambda);



X(:,1) = x0;

for k = 1:K
    X(:,k+1) = Lambda * W * X(:,k) + (I - Lambda)*a;

end
end

