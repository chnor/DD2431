function im = load_im
    
    im = {imread('step1.png'), ...
          imread('step2.png'), ...
          imread('step3.png'), ...
          imread('step4.png'), ...
          imread('step5.png'), ...
          imread('step6.png'), ...
          imread('step7.png'), ...
          imread('step8.png'), ...
          imread('step9.png'), ...
          imread('step10.png'), ...
          imread('step11.png'), ...
          imread('step12.png'), ...
          imread('step13.png'), ...
          imread('step14.png'), ...
          imread('step15.png'), ...
          imread('step16.png')};
    
    % Normalize
    for i = 1:16
        im{i} = double(im{i}) ./ double(max(max(im{i})));
    end
    
end