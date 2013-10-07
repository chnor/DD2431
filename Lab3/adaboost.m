function [mu, sigma, p, alpha, classes] = adaboost(data, T)
    
    c = data(:, end);
    x = data(:, 1:end-1);
    classes = unique(c);
    
    mu      = cell(T, 1);
    sigma   = cell(T, 1);
    alpha   = zeros(1, T);
    
    p = prior(data);
    
    w = ones(size(c));
    w = w / sum(w);
	
    for t = 1:T
        disp(['Starting iteration: ', num2str(t)]);
        
        [mu_t, sigma_t] = bayes_weight(data, w);
%         [mu_t, sigma_t] = bayes(data);
        mu{t}       = mu_t;
        sigma{t}    = sigma_t;
        [~, h] = max(discriminant(x, mu_t, sigma_t, p), [], 2);
        h = h - 1;
        
        err_t = 1 - sum(w .* (h == c));
        alpha(t) = 1 / (2*log((1 - err_t)/err_t));
        
        if t ~= T
            q = (h ~= c) - (h == c); % q_i = 1 if h_i == c_i else -1
            w_next = w .* exp(q*alpha(t));
			w_next = w_next / sum(w_next);
			w = w_next;
        end
    end
    
end