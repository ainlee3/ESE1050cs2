rng(105); 
P0 = [5*rand(50,2); 5*rand(50,2) + [6 0]];
n = 100;
rmin = 0.1;
st4 = graph_stats(makedisk(P0, rmin));
while isinf(st4.diameter)                  
    rmin = round(rmin + 0.1, 1);
    st4 = graph_stats(makedisk(P0, rmin));
end
edges4 = st4.edges;                       
kmax = floor((n - 1)/2);
ks = 1:kmax;
[~, idx] = min(abs(n*ks - edges4));
k = ks(idx);

fprintf('r_min = %.1f, T4 edges = %d, ring k = %d, T3 edges = %d\n', rmin, edges4, k, n*k);

G1 = makecomplete(n);
G2 = make_star(n);
G3 = makering(n, k);
G4 = makedisk(P0, rmin);


names = {'T1 Broadcast'; 'T2 Star'; 'T3 Ring'; 'T4 Disk'};
Gs = {G1, G2, G3, G4};

edgeCount = zeros(4,1); 
meanDeg = zeros(4,1);
maxDeg = zeros(4,1);     
diam = zeros(4,1);
for t = 1:4                          
    st = graph_stats(Gs{t});
    edgeCount(t) = st.edges;
    meanDeg(t) = mean(st.degree);
    maxDeg(t) = max(st.degree);
    diam(t) = st.diameter;
end

T = table(names, edgeCount, meanDeg, maxDeg, diam,'VariableNames', {'Network','EdgeCount','MeanDegree','MaxDegree','Diameter'});
disp(T);


[i, j] = find(triu(G4));             
figure; 
hold on;
plot([P0(i,1) P0(j,1)]', [P0(i,2) P0(j,2)]', 'Color', [0.75 0.75 0.75]);  
h1 = plot(P0(1:50,1),   P0(1:50,2),   'o', 'MarkerFaceColor', [0.1 0.5 0.8], 'MarkerEdgeColor', 'k');
h2 = plot(P0(51:100,1), P0(51:100,2), 'o', 'MarkerFaceColor', [0.9 0.5 0.1], 'MarkerEdgeColor', 'k');
axis equal; 
box on;
xlabel('x'); ylabel('y');
title(sprintf('T4 radio-range network, r = %.1f', rmin));
legend([h1 h2], {'Left zone (robots 1-50)', 'Right zone (robots 51-100)'}, 'Location', 'best');
