function Q = Q_learning(go, n_s, n_a, eta, gamma, epsilon, T)
    
    Q = rand(n_s, n_a);
    s = randi(n_s);
    
    for t = 1:T
        a = epsilon_greedy(Q, s, epsilon);
        s_r = go(s, a);
        s_prime = s_r(1);
        r       = s_r(2);
        Q(s, a) = Q(s, a) + eta*(r + gamma*max(Q(s_prime, :)) - Q(s, a));
        s = s_prime;
    end
    
end