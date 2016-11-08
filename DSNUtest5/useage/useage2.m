clear;
close all;

load('DSNU_31_2_robust.mat');
load('DSNU_31_p1p2_robust.mat');

thr = 3000;

pics = {'L2.tif'};
npics = size(pics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

for i = 1 : npics
    I = imread(pics{i});
    I_ptu = I(1 : PIC_MAX_ROW / 2, :);
    I_ptux = I_ptu;
    I_ptd = I(PIC_MAX_ROW / 2 + 1 : end, :);
    I_ptdx = I_ptd;
    for j = 1 : PIC_MAX_COL
        for k = 1 : PIC_MAX_ROW / 2
            if(I_ptux(k,j) < thr)
                I_ptux(k,j) = uint16((double(I_ptu(k, j)) - b1(1, j) - b2 - b3(1, j)) / a(1, j));
            else
                I_ptux(k,j) = uint16((double(I_ptu(k, j)) - b12(1, j) - b22 - b32(1, j)) / a2(1, j));
            end
            if(I_ptdx(k,j) < thr)
                I_ptdx(k,j) = uint16((double(I_ptd(k, j)) - b1(2, j) - b2 - b3(2, j)) / a(2, j));
            else
                I_ptdx(k,j) = uint16((double(I_ptd(k, j)) - b12(2, j) - b22 - b32(2, j)) / a2(2, j));
            end
        end
    end
    I(1 : PIC_MAX_ROW / 2, :) = I_ptux(:, :);
    I(PIC_MAX_ROW / 2 + 1 : end, :) = I_ptdx(:, :);
    imwrite(I, ['p_p1p2_3000_31_', pics{i}]);
end