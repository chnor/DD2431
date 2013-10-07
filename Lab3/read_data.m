function [data_1, data_2, test_data] = read_data()
    
    addpath('bayesboost');
    
    hand = imread('hand.ppm', 'ppm');
    book = imread('book.ppm', 'ppm');
    
    data_1 = normalize_and_label(hand, 0);
    data_2 = normalize_and_label(book, 1);
    test_data = [data_1; data_2];
    
end