function lab()
    
    addpath('bayesboost');
    
    hand = imread('hand.ppm', 'ppm');
    book = imread('book.ppm', 'ppm');
    
%     figure(1);
%     imagesc(hand);
%     figure(2);
%     imagesc(book);
    
    data_1 = normalize_and_label(hand, 0);
    data_2 = normalize_and_label(book, 1);
    test_data = [data_1; data_2];
    figure(1);
    hold on;
    plot(data_2(:, 1), data_2(:, 2), '.b');
    plot(data_1(:, 1), data_1(:, 2), '.r');
    xlabel('green');
    ylabel('red');
    
    [mu, sigma] = bayes(test_data);
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
    
    axis([0.2, 0.5, 0.2, 0.45]);
    x = 0.2:0.01:0.5;
    y = 0.2:0.01:0.45;
    [z1, z2] = meshgrid(x, y);
    z1 = reshape(z1, numel(z1), 1);
    z2 = reshape(z2, numel(z2), 1);
    g = discriminant([z1, z2], mu, sigma, p);
    gg = g(:, 1) - g(:, 2);
    gg = reshape(gg, length(y), length(x));
    [c, h] = contour(x, y, gg, [0, 0]);
    set(h, 'LineWidth', 3);
    
    book_rg = zeros(size(book, 1), size(book, 2), 2);
    for y = 1:size(book, 1)
        for x = 1:size(book, 2)
            s = sum(book(y, x, :));
            if s > 0
                book_rg(y, x, :) = double(book(y, x, 1:2))/s;
            end
        end
    end
    
    tmp = reshape(book_rg, size(book_rg, 1)*size(book_rg, 2), 2);
    g = discriminant(tmp, mu, sigma, p);
    gg = g(:, 1) - g(:, 2);
    gg = reshape(gg, size(book_rg, 1), size(book_rg, 2));
    mask = gg < 0;
    mask3D(:, :, 1) = mask;
    mask3D(:, :, 2) = mask;
    mask3D(:, :, 3) = mask;
    result_im = uint8(double(book) .* mask3D);
    figure;
    imagesc(result_im);
    
    
end