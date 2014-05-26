function [cont,vars, stds, kurt, men, smo]=feature_extraction(data_cropped_int)
        glcm = graycomatrix(data_cropped_int);
        stats = graycoprops(glcm,{'contrast'});
        cont = struct2array(stats);
        vars = var(data_cropped_int(:));
        stds = std(data_cropped_int(:));
        kurt = kurtosis(data_cropped_int(:));
        men = mean(data_cropped_int(:));
        smo = 1-(1/(1+vars));
        
        %fprintf('\tExtraction feature data %s\n', currentfilename);
        fprintf('\t\t %f\n', cont);
        fprintf('\t\t %f\n', vars);
        fprintf('\t\t %f\n', stds);
        fprintf('\t\t %f\n', kurt);
        fprintf('\t\t %f\n', men);
        fprintf('\t\t %f\n', smo);
end