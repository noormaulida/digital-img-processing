function [segmented1, segmented2] = segmentation(enhanceddata)     
    %---------------
    %segmentasi
    %iterative threshold (otsu)
    %---------------
    sizes = size(enhanceddata)
    row = sizes(1);
    col = sizes(2);
    %mengambil background image
    background = imopen(enhanceddata,strel('disk',10));
    %mengambil image tanpa background
    I2 = enhanceddata - background;
    I3 = imadjust(I2);

    level_threshold = fungsi_graythresh(I3);

    citra = zeros(row, col);

    for i=1:row
        for j=1:col
            if enhanceddata(i,j)> level_threshold
                citra(i,j) = 1;
            else
                citra(i,j) = 0;
            end
        end
    end

    %stats = regionprops(citra,'Area','Centroid');

    batas_atas = 1;
    batas_bawah = 1;
    batas_kanan = 1;
    batas_kiri = 1;

    while (true)
        for i=1:row
            for j=1:col
                if citra(i,j) == 1
                    %if i > batas_atas
                        batas_bawah = i;
                        break;
                    %end
                end
            end
        end
        break;
    end

    while (true)
        for j=1:col
            for i=1:row
                if citra(i,j) == 1
                    %if j > batas_kiri
                        batas_kanan = j;
                        break;
                   % end
                end
            end
        end
        break;
    end

    while (true)
        for i=row:-1:1
            for j=col:-1:1
                if citra(i,j) == 1
                    %if i > batas_bawah
                        batas_atas = i;
                        break;
                    %end
                end
            end
        end
        break;
    end

    while (true)
        for j=col:-1:1
            for i=row:-1:1
                if citra(i,j) == 1
                    %if j > batas_kanan
                        batas_kiri = j;
                        break;
                    %end
                end
            end
        end
        break;
    end

    data_cropped_double = zeros(batas_bawah-batas_atas+1, batas_kanan-batas_kiri+1);
    data_cropped_int = zeros(batas_bawah-batas_atas+1, batas_kanan-batas_kiri+1);

    %set crop
    for i=batas_atas:batas_bawah
        for j=batas_kiri:batas_kanan
            data_cropped_double ((i-batas_atas)+1,(j-batas_kiri)+1) = citra (i,j);
            data_cropped_int ((i-batas_atas)+1, (j-batas_kiri)+1) = enhanceddata(i,j);
        end
    end
    
    segmented1 = data_cropped_double;
    segmented2 = data_cropped_int;
end