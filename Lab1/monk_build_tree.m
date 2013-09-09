function T = monk_make_tree(S, used, values, depth, max_depth)
    
    if depth == max_depth
        T = used';
        for i = 1:length(used)
            disp(['a', num2str(used(i)), ' = ' , num2str(values(i))]);
        end
        disp(['Decision: ' , num2str(majority_class(S))]);
        return;
    end
    
    candidates = 1:(size(S, 2)-1);
    candidates = setdiff(candidates, used);
    gains = arrayfun(@(attr) gain(S, attr), candidates);
    [~, index] = max(gains);
    attr = candidates(index);
    
    disp(['Splitting on ' , num2str(attr)]);
    
    T = []
    
    K = unique(S(:, attr))';
    for k = K
        S_k = S(S(:, attr) == k, :);
        disp(['Recursing to ' , num2str(k)]);
        T = [T, monk_make_tree(S_k, [used, attr], [values, k], depth+1, max_depth)];
    end
end