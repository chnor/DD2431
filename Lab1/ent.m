function entropy = ent(data)
    entropy = ent_1(sum(data(:, end) == 1) / size(data, 1));
end

function entropy = ent_1(p_0)
    if p_0 == 0
        entropy = 0;
        return;
    end
    if p_0 == 1
        entropy = 0;
        return;
    end
    p_1 = 1 - p_0;
    entropy = -p_0 * log2(p_0) - p_1 * log2(p_1);
end