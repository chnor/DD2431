function g = gain(S, attr)
    K = unique(S(:, attr))';
    g = ent(S);
    for k = K
        S_k = S(S(:, attr) == k, :);
        g = g - (size(S_k, 1)/size(S, 1))*ent(S_k);
    end
end