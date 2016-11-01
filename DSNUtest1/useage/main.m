clear;
close all;

load('up_part_data.mat');
pics = {'109.tif','209.tif','309.tif','509.tif'};

npics = size(pics, 2);
narea_col = areaRD(1) + 1 - areaLU(1);
narea_row = areaRD(2) + 1 - areaLU(2);

for i = 1:npics
    pic = pics{i};
    I_ = imread(pic);
    for j = 1:size(I_, 2)
        if(j >= areaLU(1) && j <= areaRD(1))
            I_(:,j) = para(1, j - areaLU(1) + 1) * I_(:,j) + para(2, j - areaLU(1) + 1);
        end
    end
    imwrite(I_, ['p_',pic]);
end
