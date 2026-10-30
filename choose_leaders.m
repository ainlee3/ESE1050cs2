function S = choose_leaders(G, P0, faulty, g, m)
%CHOOSE_LEADERS  Choose which robots become leaders (ESE 105, Case Study II, Part III).
%
%   S = choose_leaders(G, P0, faulty, g, m)
%
%   Inputs
%     G       n-by-n adjacency matrix of the communication network
%     P0      n-by-2 landing positions; row i is robot i's (x, y)
%     faulty  vector of indices of robots with broken drives
%     g       1-by-2 rally point
%     m       maximum number of leaders
%
%   Output
%     S       vector of at most m distinct robot indices, none of them faulty
%
%   Rules (see Section D.4 of the handout)
%     - Use only the network's structure: anything you can compute from G,
%       P0, faulty and g with the tools from Part I (degrees, hop counts,
%       distances, products and powers of G, ...).
%     - Do NOT simulate the swarm, and do NOT call score_mission.
%     - Must run in under 2 seconds on one deployment.
%     - Do not change the function name or the order of the inputs.
%       Helper functions are allowed, but put them in this file, below
%       this function, so that this single file is all we need to run it.
%
%   Team: Case study Group 5
%   Members: Alex Chen, Evelyn Lee, Caleb Collins
%
%   Strategy (2-3 sentences describing your rule, in words): We are going
%   to implement a strategy that is going to spread out the leaders more so
%   that we do not have leaders that are all in one cluster. We would do
%   this by picking out the highest degree robot that is more than a hop
%   away from the previous leader.
%   
%   


n = size(G, 1);
working = true(n, 1);
working(faulty) = false;
one = ones(n, 1);
d = G*one;
S = zeros(0, 1);


M = eye(n) + G;
k = 1;

diameter = (M)^k > 0;


for pick = 1:m
    if ~any(working)
        break                           
    end
    workingRobots = find(working); 
    workingDegrees = d(workingRobots);
    [~, idx] = max(workingDegrees);         
    leader = workingRobots(idx);              
    S(end + 1, 1) = leader;                  
    working(diameter(:, leader)) = 0;  
end



  


end











