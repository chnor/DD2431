function plot_simple_bayes(data_1, data_2, mu, sigma)
    
    test_data = [data_1; data_2];
    
    plot(data_2(:, 1), data_2(:, 2), '.b');
    hold on;
    plot(data_1(:, 1), data_1(:, 2), '.r');
    xlabel('green');
    ylabel('red');
    
%     [mu, sigma] = bayes(test_data);
    theta = 0:0.01:2*pi;
    x1 = 2*sigma(1, 1)*cos(theta) + mu(1, 1);
    y1 = 2*sigma(1, 2)*sin(theta) + mu(1, 2);
    x2 = 2*sigma(2, 1)*cos(theta) + mu(2, 1);
    y2 = 2*sigma(2, 2)*sin(theta) + mu(2, 2);
    hold on;
    plot(x1, y1, 'r');
    plot(x2, y2, 'b');
    
    [M, N] = size(test_data);
    p = prior(test_data);
    g = discriminant(test_data(:, 1:2), mu, sigma, p);
    [~, class] = max(g, [], 2);
    class = class - 1;
    error_test = 1.0 - sum(class == test_data(:, end)) / M
    
%     ax = [min(test_data(:, 1)) - 0.2, max(test_data(:, 1)) + 0.2, min(test_data(:, 2)) - 0.2, max(test_data(:, 2)) + 0.2];
    ax = [0.2, 0.5, 0.2, 0.45];
    axis(ax);
    x = ax(1):0.01:ax(2);
    y = ax(3):0.01:ax(4);
    [z1, z2] = meshgrid(x, y);
    z1 = reshape(z1, numel(z1), 1);
    z2 = reshape(z2, numel(z2), 1);
    g = discriminant([z1, z2], mu, sigma, p);
    gg = g(:, 1) - g(:, 2);
    gg = reshape(gg, length(y), length(x));
    [~, h] = contour(x, y, gg, [0, 0], 'k');
    set(h, 'LineWidth', 2);
    
    hold off;
    
end