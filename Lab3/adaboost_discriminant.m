function c = adaboost_discriminant(data, mu, sigma, p, alpha, classes, T)
    
    assert(length(sigma) == T);
    assert(length(mu) == T);
    
    response = zeros(size(data));
    for t = 1:T
        response = response + alpha(t)*discriminant(data, mu{t}, sigma{t}, p);
    end
    
    [~, i] = max(response, [], 2);
    c = i - 1;
    
end