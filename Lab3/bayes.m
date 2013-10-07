function [mu, sigma] = bayes(data)
    
    labels = data(:, end);
    x = data(:, 1:end-1);
    classes = unique(labels);
    
    mu      = zeros(size(x, 2));
    sigma   = zeros(size(x, 2));
    i = 0;
    for label = classes'
        i = i + 1;
        mu(i, :)    = mean(x(labels == label, :), 1);
        sigma(i, :) = std(x(labels == label, :), 1);
    end
    
end