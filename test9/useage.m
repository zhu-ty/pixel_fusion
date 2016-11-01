clear;
close all;

load('DSNU.mat');

pics = {'L2.tif'};
npics = size(pics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

for i = 1 : npics
    I = imread(pics{i});
    I_ptu = I(1 : PIC_MAX_ROW / 2, :);
    I_ptd = I(PIC_MAX_ROW / 2 + 1 : end, :);
    for j = 1 : PIC_MAX_COL
        I_ptu(:, j) = uint16(a(1, j) * I_ptu(:, j) - b1(1, j) - b2 + b3(1, j));
        I_ptd(:, j) = uint16(a(2, j) * I_ptd(:, j) - b1(2, j) - b2 + b3(2, j));
    end
    I(1 : PIC_MAX_ROW / 2, :) = I_ptu(:, :);
    I(PIC_MAX_ROW / 2 + 1 : end, :) = I_ptd(:, :);
    imwrite(I, ['p_', pics{i}]);
end