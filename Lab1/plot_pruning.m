function plot_pruning(r, text)
    
    plot(r.phi, r.epsilon, '--', r.phi, r.epsilon_prime);
    legend('no pruning', 'pruning');
    title(text);
    xlabel('frac');
    ylabel('classification error');
    
end