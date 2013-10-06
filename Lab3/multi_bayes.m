function [mu, C] = multi_bayes(data)
    
    labels = data(:, end);
    x = data(:, 1:end-1);
    classes = unique(labels);
    
    mu = zeros(numel(classes));
    C  = cell(numel(classes), 1);
    i = 0;
    for label = classes'
        i = i + 1;
        mu(i, :)    = mean(x(labels == label, :), 1);
        x_i = x(labels == label, :);
        C{i} = x_i'*x_i;
    end
    
end