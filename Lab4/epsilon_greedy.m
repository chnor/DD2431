function a = epsilon_greedy(Q, s, epsilon)
    if rand > epsilon
        [~, a] = max(Q(s, :));
    else
        a = randi(size(Q, 2));
    end
end