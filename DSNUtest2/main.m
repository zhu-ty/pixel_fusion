clear;
close all;

%const
bpics = {'black(1).tif','black(2).tif','black(3).tif'};
lpics = {'light(1).tif','light(2).tif','light(3).tif','light(4).tif','light(5).tif','light(6).tif'};
nbpics = size(bpics, 2);
nlpics = size(lpics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

%must be odd!
SAMP_COL_LEN = 51;
SAMP_ROW_LEN = 51;

%model
%y=ax+b1+b2+b3;
a = zeros(2, PIC_MAX_COL);
b1 = zeros(2, PIC_MAX_COL);
b2 = 0;
b3 = zeros(2, PIC_MAX_COL);

%cal b2
tmp_b2 = zeros(nbpics, 1);
for i = 1 : nbpics
    tmp_I = imread(bpics{i});
    tmp_b2(i, 1) = mean(mean(tmp_I));
end
b2 = mean(tmp_b2);

%cal b1
for i = 1 : nbpics
    tmp_I = imread(bpics{i});
    tmp_I = int32(tmp_I) - b2;
    tmp_I_pt1 = tmp_I(1 : PIC_MAX_ROW / 2, :);
    tmp_I_pt2 = tmp_I(PIC_MAX_ROW / 2 + 1 : end, :);
    b1(1, :) = b1(1, :) + mean(tmp_I_pt1);
    b1(2, :) = b1(2, :) + mean(tmp_I_pt2);
end
b1 = b1 / nbpics;

%cal a,b3
x_list_u = zeros(SAMP_ROW_LEN * nlpics, PIC_MAX_COL);
y_list_u = zeros(nlpics, PIC_MAX_COL);
x_list_d = zeros(SAMP_ROW_LEN * nlpics, PIC_MAX_COL);
y_list_d = zeros(nlpics, PIC_MAX_COL);

for i = 1 : nlpics
    tmp_I = imread(lpics{i});
    [y_list_i, x_list_i] = img_data_generator(tmp_I, b1, b2,...
        PIC_MAX_ROW, PIC_MAX_COL, SAMP_ROW_LEN, SAMP_COL_LEN);
    x_list_u((i - 1) * SAMP_ROW_LEN + 1 : i * SAMP_ROW_LEN, :) = x_list_i(1 : SAMP_ROW_LEN, :);
    x_list_d((i - 1) * SAMP_ROW_LEN + 1 : i * SAMP_ROW_LEN, :) = x_list_i(SAMP_ROW_LEN + 1 : end, :);
    y_list_u(i, :) = y_list_i(1, :);
    y_list_d(i, :) = y_list_i(2, :);
end

y_list_u = kron(y_list_u, ones(SAMP_ROW_LEN, 1));
y_list_d = kron(y_list_d, ones(SAMP_ROW_LEN, 1));

for i = 1 : PIC_MAX_COL
    tmp_para = polyfit(x_list_u(:, i), y_list_u(:, i), 1);
    a(1, i) = tmp_para(1);
    b3(1, i) = tmp_para(2);
    tmp_para = polyfit(x_list_d(:, i), y_list_d(:, i), 1);
    a(2, i) = tmp_para(1);
    b3(2, i) = tmp_para(2);
end

%save
save('DSNU.mat','a','b1','b2','b3');