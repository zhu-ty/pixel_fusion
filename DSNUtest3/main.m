clear;
close all;

%const
bpics = {'p_black(1).tif','p_black(2).tif','p_black(3).tif'};
lpics = {'p_light(1).tif','p_light(2).tif','p_light(3).tif','p_light(4).tif','p_light(5).tif','p_light(6).tif'};
nbpics = size(bpics, 2);
nlpics = size(lpics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

%must be odd!
SAMP_COL_LEN = 201;
SAMP_ROW_LEN = 201;

%model
%y=output
%x=real
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
y_list_u = zeros(SAMP_ROW_LEN * nlpics, PIC_MAX_COL);
x_list_u = zeros(nlpics, PIC_MAX_COL);
y_list_d = zeros(SAMP_ROW_LEN * nlpics, PIC_MAX_COL);
x_list_d = zeros(nlpics, PIC_MAX_COL);

for i = 1 : nlpics
    tmp_I = imread(lpics{i});
    [x_list_i, y_list_i] = img_data_generator(tmp_I, b1, b2,...
        PIC_MAX_ROW, PIC_MAX_COL, SAMP_ROW_LEN, SAMP_COL_LEN);
    y_list_u((i - 1) * SAMP_ROW_LEN + 1 : i * SAMP_ROW_LEN, :) = y_list_i(1 : SAMP_ROW_LEN, :);
    y_list_d((i - 1) * SAMP_ROW_LEN + 1 : i * SAMP_ROW_LEN, :) = y_list_i(SAMP_ROW_LEN + 1 : end, :);
    x_list_u(i, :) = x_list_i(1, :);
    x_list_d(i, :) = x_list_i(2, :);
end

x_list_u = kron(x_list_u, ones(SAMP_ROW_LEN, 1));
x_list_d = kron(x_list_d, ones(SAMP_ROW_LEN, 1));

%fitp = zeros(2, PIC_MAX_COL,2,2);

for i = 1 : PIC_MAX_COL
    tmp_para = polyfit(x_list_u(:, i), y_list_u(:, i), 1);
    %fitp(1, i,:,:) = corrcoef(x_list_u(:, i), y_list_u(:, i));
    a(1, i) = tmp_para(1);
    b3(1, i) = tmp_para(2);
    tmp_para = polyfit(x_list_d(:, i), y_list_d(:, i), 1);
    %fitp(2, i,:,:) = corrcoef(x_list_d(:, i), y_list_d(:, i));
    a(2, i) = tmp_para(1);
    b3(2, i) = tmp_para(2);
end

%save
save('DSNU_201_2.mat','a','b1','b2','b3');

if(0)
    plot(x_list_u(:,100),y_list_u(:,100) + b1(1,100) + b2 ,'+');
    hold on;
    x = 0:5000:50000;
    y = polyval([a(1,100),b1(1,100) + b2 + b3(1,100)],x);
    plot(x,y);
end

