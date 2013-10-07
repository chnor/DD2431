function [mu, sigma] = bayes_weight(data, w)
    
    labels = data(:, end);
    x = data(:, 1:end-1);
    classes = unique(labels);
    
    mu      = zeros(size(x, 2));
    sigma   = zeros(size(x, 2));
    i = 0;
    for label = classes'
        i = i + 1;
        x_i = x(labels == label, :);
        w_i = w(labels == label, :);
        w_i = w_i / sum(w_i);
        mu(i, :)    = sum(bsxfun(@times, x_i, w_i), 1);
        % There's no equivalent for std or (mean)
        sigma(i, :) = sqrt(var(x_i, w_i, 1));
    end
    
end