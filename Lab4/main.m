function main
    
    addpath('rl');
    
    trans = [2, 4, 5, 13;
             1, 3, 6, 14;
             4, 2, 7, 15;
             3, 1, 8, 16;
             6, 8, 1, 9;
             5, 7, 2, 10;
             8, 6, 3, 11;
             7, 5, 4, 12;
             10, 12, 13, 5;
             9, 11, 14, 6;
             12, 10, 15, 7;
             11, 9, 16, 8;
             14, 16, 9, 1;
             13, 15, 10, 2;
             16, 14, 11, 3;
             15, 13, 12, 4];
    
    im = load_im;
    
    balance = [3 4 8 9 12 13 14 15];
    
%     rew = bsxfun(@(s, a) trans(s, a) > s, (1:16)', (1:4));
    rew = zeros(16, 4);
%     rew(4, 8) = 1;
%     rew(8, 9) = 1;
    rew(9,  3)  =  1;
    rew(3,  1)  =  1;
    rew(13, 3)  = -1;
    rew(4,  1)  = -1;
    for s = 1:16
        for a = 1:4
            rew(s, a) = rew(s, a) - ~any(trans(s, a) == balance);
        end
    end
    [policy, value] = policy_iteration(rew, trans, 0.9);
    
    s    = zeros(1, 20);
    s(1) = 4;
    for i = 2:length(s);
        s(i) = trans(s(i-1), policy(s(i-1)));
    end
    
    walkshow(s, im);
%     animate(s, im);
    
end