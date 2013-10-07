function complex_example(n_1, n_2)
    
    mu_1    = 100*rand(n_1, 2);
    sigma_1 = abs(randn(n_1, 2))+1;
    mu_2    = 100*rand(n_2, 2);
    sigma_2 = abs(randn(n_2, 2))+1;
    
    p_1 = [];
    for i = 1:n_1
        p_1 = [p_1; bsxfun(@plus, bsxfun(@times, sigma_1(i, :), randn(50, 2)), mu_1(i, :))];
    end
    p_1 = [p_1, zeros(size(p_1, 1), 1)];
    
    p_2 = [];
    for i = 1:n_2
        p_2 = [p_2; bsxfun(@plus, bsxfun(@times, sigma_2(i, :), randn(50, 2)), mu_2(i, :))];
    end
    p_2 = [p_2, ones(size(p_2, 1), 1)];
    
    plot(p_1(:, 1), p_1(:, 2), 'b.');
    hold on;
    plot(p_2(:, 1), p_2(:, 2), 'r.');
    
    [mu, sigma] = bayes([p_1; p_2]);
    plot_simple_bayes(p_1, p_2, mu, sigma);
    
    T = 20;
    plot_boosted(p_1, p_2, T)
%     [mu, sigma, p, alpha, classes] = adaboost(test_data, T);
    
end