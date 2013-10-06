function g = discriminant(x, mu, sigma, p)
    
    g = repmat(log(p), [size(x, 1), 1]);
    for i = 1:size(mu, 1)
        g(:, i) = g(:, i) - sum(log(sigma(i, :)));
        g(:, i) = g(:, i) - sum(bsxfun(@rdivide, bsxfun(@minus, x, mu(i, :)).^2, 2*sigma(i, :).^2), 2);
    end
    
end