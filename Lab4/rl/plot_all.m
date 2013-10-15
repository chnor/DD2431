function plot_all(im)
    states = [1:4; 5:8; 9:12; 13:16];
    p = cell2mat(im(states));
    imshow(p);
end
