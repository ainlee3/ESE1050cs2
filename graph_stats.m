function stats = graph_stats(G)

s = size(G,1);
one = ones(s, 1);
d = G*one;
edge_count = 1/2*one'*G*one;

M = eye(s) + G;
R = M;
diameter = Inf;

for k = 1:s

    if all(R > 0)
    diameter = k;
    break
    end
    R = double(M*R > 0);
end


stats.degree = d;
stats.edges = edge_count;
stats.diameter = diameter;


end

