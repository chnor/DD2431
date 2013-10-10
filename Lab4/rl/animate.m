function animate(states, im)
    assert(any(size(states) == 1)); % Assert one dimensional 
    for i = 1:length(states)
        imshow(im{states(i)});
        drawnow;
        if i ~= length(states)
            pause(0.17);
        end
    end
end
