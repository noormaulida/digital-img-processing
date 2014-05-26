function enhanceddata=enhancement(data3)     
    data = rgb2gray(data3);
    sizes = size(data);
    row = sizes (1);
    col = sizes (2);

    %---------------
    %pre-processing
    %algoritma possibility distribusi pendekatan logika fuzzi
    %--------------- 
    enhanceddata = possibility_distribution(data,row,col);
end