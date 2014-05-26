function net=training()
imgPath = '.\Data Training'; 
files = dir(fullfile(imgPath, '*.jpg')); 
%files = dir('*.jpg');      
nfiles = length(files);
hasil = zeros(nfiles,6);
target = zeros(nfiles,2);

fprintf('-------------------------\n');
for ii=1:nfiles
    currentfilename = [imgPath '\' files(ii).name];
    currentimage = im2double(imread(currentfilename));
    images{ii} = currentimage;
    data = rgb2gray(images{ii});
    sizes = size(data);
    row = sizes (1);
    col = sizes (2);
    
    check = 0;
    if strfind(currentfilename, 'cancer') 
        check = check+1;
    elseif strfind(currentfilename, 'normal') 
        check = check+1;
    end
        
    if check == 1
        fprintf('%d) Input file: %s\n', ii, currentfilename);
        %fprintf('\tPre processing noise removal %s\n', currentfilename);

        %---------------
        %pre-processing
        %enhanced data algoritma possibility distribution pendekatan fuzzi
        %--------------- 
        enhanceddata = possibility_distribution(data,row,col);
        fprintf('\tPre processing enhancement data %s\n', currentfilename);

        %---------------
        %segmentasi
        %iterative threshold (otsu)
        %---------------

        background = imopen(enhanceddata,strel('disk',15));
        I2 = enhanceddata - background;
        I3 = imadjust(I2);

        level_threshold = fungsi_graythresh(I3);

        citra = zeros(row, col);

        for i=1:row
            for j=1:col
                if I3(i,j)> level_threshold
                    citra(i,j) = 1;
                else
                    citra(i,j) = 0;
                end
            end
        end

        fprintf('\tSegmentation data %s\n', currentfilename);

        batas_atas = 1;
        batas_bawah = 1;
        batas_kanan = 1;
        batas_kiri = 1;

        while (true)
            for i=1:row
                for j=1:col
                    if citra(i,j) == 1
                            batas_bawah = i;
                            break;
                    end
                end
            end
            break;
        end

        while (true)
            for j=1:col
                for i=1:row
                    if citra(i,j) == 1
                            batas_kanan = j;
                            break;
                    end
                end
            end
            break;
        end

        while (true)
            for i=row:-1:1
                for j=col:-1:1
                    if citra(i,j) == 1
                            batas_atas = i;
                            break;
                    end
                end
            end
            break;
        end

        while (true)
            for j=col:-1:1
                for i=row:-1:1
                    if citra(i,j) == 1
                            batas_kiri = j;
                            break;
                    end
                end
            end
            break;
        end
        
        fprintf('\tCropping data %s\n', currentfilename);
        data_cropped_double = zeros(batas_bawah-batas_atas+1, batas_kanan-batas_kiri+1);
        data_cropped_int = zeros(batas_bawah-batas_atas+1, batas_kanan-batas_kiri+1);

        %set crop
        for i=batas_atas:batas_bawah
            for j=batas_kiri:batas_kanan
                data_cropped_double ((i-batas_atas)+1,(j-batas_kiri)+1) = citra (i,j);
                data_cropped_int ((i-batas_atas)+1, (j-batas_kiri)+1) = enhanceddata(i,j);
            end
        end

        %---------------
        %fitur ekstraksi
        %---------------
        glcm = graycomatrix(data_cropped_int);
        stats = graycoprops(glcm,{'contrast'});
        cont = struct2array(stats);
        vars = var(data_cropped_int(:));
        stds = std(data_cropped_int(:));
        kurt = kurtosis(data_cropped_int(:));
        men = mean(data_cropped_int(:));
        smo = 1-(1/(1+vars));
        
        fprintf('\tExtraction feature data %s\n', currentfilename);
        fprintf('\t\t %f\n', cont);
        fprintf('\t\t %f\n', vars);
        fprintf('\t\t %f\n', stds);
        fprintf('\t\t %f\n', kurt);
        fprintf('\t\t %f\n', men);
        fprintf('\t\t %f\n', smo);

        hasil(ii, 1) = cont;
        hasil(ii, 2) = vars;
        hasil(ii, 3) = stds;
        hasil(ii, 4) = kurt; 
        hasil(ii, 5) = men;
        hasil(ii, 6) = smo;    

        if(strfind(currentfilename, 'normal'))
            target(ii, 1) = 1;
            target(ii, 2) = 0;
        elseif(strfind(currentfilename, 'cancer'))
            target(ii, 1) = 0;
            target(ii, 2) = 1;
        end
    end
end

%---------------
%training
%---------------
inputs = hasil';
targets = target';
hiddenLayerSize = 5;
net = patternnet(hiddenLayerSize);
net.divideParam.trainRatio = 100/100;
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false; 
[net,tr] = train(net,inputs,targets);
net
end