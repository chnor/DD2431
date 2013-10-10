function [policy, value] = policy_iteration(rew, trans, g)
    
    [m, ~]  = size(rew);
    policy  = ones(1, m);
    value   = zeros(1, m);
    
    for p = 1:100
        for s = 1:m
            [~, policy_s] = max(rew(s, :) + g * value(trans(s, :)));
            policy(s) = policy_s;
        end
        for s = 1:m
            a = policy(s);
            value(s) = rew(s, a) + g * value(trans(s , a));
        end
    end
    
end