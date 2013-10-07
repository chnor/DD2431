function remove_hand_simple(book, mu, sigma, p)
    
    book_rg = zeros(size(book, 1), size(book, 2), 2);
    for y = 1:size(book, 1)
        for x = 1:size(book, 2)
            s = sum(book(y, x, :));
            if s > 0
                book_rg(y, x, :) = double(book(y, x, 1:2))/s;
            end
        end
    end
    
    tmp = reshape(book_rg, size(book_rg, 1)*size(book_rg, 2), 2);
    g = discriminant(tmp, mu, sigma, p);
    gg = g(:, 1) - g(:, 2);
    gg = reshape(gg, size(book_rg, 1), size(book_rg, 2));
    mask = gg < 0;
    mask3D(:, :, 1) = mask;
    mask3D(:, :, 2) = mask;
    mask3D(:, :, 3) = mask;
    result_im = uint8(double(book) .* mask3D);
    figure;
    imagesc(result_im);
    
    
end