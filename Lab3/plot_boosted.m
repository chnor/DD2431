function plot_boosted(data_1, data_2, T)
    
    test_data = [data_1; data_2];
    
    [mu, sigma, p, alpha, classes] = adaboost(test_data, T);
    
    hold on;
    plot(data_2(:, 1), data_2(:, 2), '.b');
    plot(data_1(:, 1), data_1(:, 2), '.r');
    xlabel('green');
    ylabel('red');
    
    ax = [min(test_data(:, 1)) - 0.2, max(test_data(:, 1)) + 0.2, min(test_data(:, 2)) - 0.2, max(test_data(:, 2)) + 0.2];
    axis(ax);
    x = ax(1):(ax(2)-ax(1))/100:ax(2);
    y = ax(3):(ax(2)-ax(1))/100:ax(4);
    [z1, z2] = meshgrid(x, y);
    z1 = reshape(z1, numel(z1), 1);
    z2 = reshape(z2, numel(z2), 1);
    g = adaboost_discriminant([z1, z2], mu, sigma, p, alpha, classes, T);
    gg = reshape(g, length(y), length(x));
    [~, h] = contour(x, y, gg, [0, 0], 'k');
    set(h, 'LineWidth', 2);
    
end