function hasil = possibility_distribution(data, row, col)

newgraylevel = zeros(row,col);
fuzzydata = zeros(row,col);
enhanceddata = zeros(row,col);

min = 256;
maks = 1;

for i=1:row
    for j=1:col
        if data(i,j) < min
            min = data(i,j);
        end
        
        if data(i,j) > maks
            maks = data(i,j);
        end
        
    end
end

means = mean2(data);

b1 = (min+means)/2;
b2 = (maks+means)/2;

%fuzzification
for i=1:row
    for j=1:col
        if (data(i,j)>= min) && (data(i,j) < b1)
            newgraylevel(i,j) = 2*(((data(i,j)-min)/(means-min))^2);
        end
        if (data(i,j)>= b1) && (data(i,j) < means)
            newgraylevel(i,j) = 1-(2*(((data(i,j)-means)/(means-min))^2));
        end
        if (data(i,j)>= means) && (data(i,j) < b2)
            newgraylevel(i,j) = 1-(2*(((data(i,j)-means)/(maks-means))^2));
        end
        if (data(i,j)>= b2) && (data(i,j) < maks)
            newgraylevel(i,j) = 2*(((data(i,j)-means)/(maks-means))^2);
        end
    end
end

%modification
for i=1:row
    for j=1:col
        fuzzydata(i,j) = newgraylevel(i,j)^2;
    end
end

%defuzzification
for i=1:row
    for j=1:col
        enhanceddata(i,j) = fuzzydata(i,j)*data(i,j);
    end
end
%figure, imshow(enhanceddata);

hasil = enhanceddata;