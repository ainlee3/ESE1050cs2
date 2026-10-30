%%Plot for Different Points

seeds = [3 4 5 7 20 200];
for t = 1:numel(seeds)
    D = make_deployment(seeds(t));
    figure;
    gplot(D.G, D.P0);                                 
    hold on
    plot(D.P0(:,1), D.P0(:,2), 'k.', 'MarkerSize', 8);  
    hF = plot(D.P0(D.faulty,1), D.P0(D.faulty,2), 'o', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');            
    hG = plot(D.g(1), D.g(2), 'o', 'MarkerSize', 12, ...
        'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k');            
    axis equal
    title(sprintf('Seed %d', D.seed));
    legend([hF hG], {'Faulty robot', 'Rally point g'}, 'Location', 'best');
    hold off
end


%% Plot for Our Strategy


seeds = [3 4 5 7 20 200];
for t = 1:numel(seeds)
    D = make_deployment(seeds(t));
    S = choose_leaders(D.G, D.P0, D.faulty, D.g, 4);
    figure;
    gplot(D.G, D.P0);                                 
    hold on
    plot(D.P0(:,1), D.P0(:,2), 'k.', 'MarkerSize', 8, 'Color', '[1 1 1]');  
    faultyRobot = plot(D.P0(D.faulty,1), D.P0(D.faulty,2), 'o', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');            
    rallyPoint = plot(D.g(1), D.g(2), 'o', 'MarkerSize', 12, ...
        'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k');

    leader = plot(D.P0(S,1), D.P0(S,2), 'o', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');

    axis equal
    title(sprintf('Seed %d', D.seed));
    legend([faultyRobot rallyPoint leader], {'Faulty robot', 'Rally point g', 'Leader'}, 'Location', 'best');
    hold off
end