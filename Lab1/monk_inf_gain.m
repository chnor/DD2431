function R = monk_inf_gain(d1, d2, d3)
    R = zeros(3, 6);
    for i = 1:6
        R(1, i) = gain(d1, i);
        R(2, i) = gain(d2, i);
        R(3, i) = gain(d3, i);
    end
end