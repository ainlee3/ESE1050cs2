%% Part III: Steady State, no leaders
D = make_deployment(7);                
n = size(D.G, 1);                      
e = ones(n, 1);
W = (eye(n) + diag(D.G*e)) \ (eye(n) + D.G);    

S = [];                                
lambda = ones(n, 1);
lambda(S) = 0.5;
lambda(D.faulty) = 0;

xPos = D.P0(:,1);   
xPos(S) = D.g(1);         
yPos = D.P0(:,2);   
yPos(S) = D.g(2); 

K = 20000;

Lambda = diag(lambda);

M = eye(n) - Lambda*W;

xstar = M \ ((eye(n) - Lambda)*xPos);      
ystar = M \ ((eye(n) - Lambda)*yPos);     
X = simulate_anchored(W, lambda, xPos, x0, K);
Y = simulate_anchored(W, lambda, yPos, y0, K);

norm(X(:,end) - xstar)                             
norm(xstar - (Lambda*W*xstar + (eye(n)-Lambda)*xPos))  
norm(Y(:,end) - ystar)                                     
norm(ystar - (Lambda*W*ystar + (eye(n)-Lambda)*yPos))

%The numbers seem to go pretty close to 0 after 20000 steps, which means 
% that simulate anchored works the way it is supposed to.

%% Simulate Choosing Leaders Based on...
seed = 20;
avg = 0;
sum = 0;
for k = 1 : seed
D = make_deployment(k);
S = choose_leaders(D.G, D.P0, D.faulty, D.g, 4);
J = score_mission(D, S);
sum = (sum + J);
avg = sum / seed;
end
disp(avg);

% Highest Degree: Average J score with 20 seeds = 40.6036
% Highest Degree: Average J score with 100 seeds = 44.5888
% Highest Degree: Average J score with 1000 seeds = 39.4490
% Closest to rally point: Average J score with 20 seeds = 7.9708
% Closest to rally point: Average J score with 100 seeds = 9.0213
% Closest to rally point: Average J score with 1000 seeds = 10.1817
% Random Robots: Average J score with 20 seeds = 48.9742
% Random Robots: Average J score with 100 seeds = 53.2952
% Random Robots: Average J score with 1000 seeds = 49.0812
% Our Strategy: Average J score with 20 seeds = 62.3505
% Our Strategy: Average J score with 100 seeds = 60.5653
% Our Strategy: Average J score with 1000 seeds = 58.1750      


%%Find Worst Case Scores from Seeds 1 - 20
%Worst Case Scores for our Strategy: Seed 5 - J Score 36.1305
%Worst Case Scores for Highest Degree: Seed 12 - J Score 0.9188
%Worst Case Scores for Closest to Rally Point: Seed 4 - J Score 0.3416
%Worst Case Score for Random Leaders: Seed 4 - J Score 0.45


seeds = 1:20;                         
Js = zeros(numel(seeds), 1);
for k = 1:numel(seeds)
    D = make_deployment(seeds(k));
    S = choose_leaders(D.G, D.P0, D.faulty, D.g, 4);
    Js(k) = score_mission(D, S);
end


[sortedJ, order] = sort(Js);
bottom5 = [seeds(order(1:5))' sortedJ(1:5)];
disp(bottom5);
