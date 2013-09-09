
function [epsilon, epsilon_prime] = test_pruning(data, data_test, phi, ITER)
%     phi = 0.3:0.005:0.8;
    epsilon = zeros(size(phi));
    epsilon_prime = zeros(size(phi));
%     ITER = 200;
    
    for i = 1:size(phi, 2)
        [n, ~] = size(data);
        frac = phi(i);
        
        disp(['Iteration ', num2str(i), '/', num2str(numel(phi))]);
        
        for j = 1:ITER
            p = randperm(n);
            data_new = data(p(1:floor(n*frac)), :);
            data_prune = data(p(floor(n*frac)+1:n), :);
            T = build_tree(data_new);
            T_p = prune_tree(T, data_prune);
            epsilon(i) = epsilon(i) + calculate_error(T, data_test) / ITER;
            epsilon_prime(i) = epsilon_prime(i) + calculate_error(T_p, data_test) / ITER;
        end
    end
    
    plot(phi, epsilon, phi, epsilon_prime);
    
end