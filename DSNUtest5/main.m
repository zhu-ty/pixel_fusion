clear;
close all;

%const
bpics = {'black(1).tif','black(2).tif','black(3).tif'};
% lpics = {'(1).tif','(2).tif','(3).tif','(4).tif','(5).tif',...
%     '(6).tif','(7).tif','(8).tif','(9).tif','(10).tif'};
lpics = {...
    '(1).tif','(2).tif','(3).tif','(4).tif','(5).tif'...
    ,'(6).tif','(7).tif','(8).tif','(9).tif','(10).tif'...
    ,'(11).tif','(12).tif','(13).tif','(14).tif','(15).tif'...
    ,'(16).tif','(17).tif','(18).tif','(19).tif','(20).tif'...
    ,'light(1).tif','light(2).tif','light(3).tif','light(4).tif','light(5).tif','light(6).tif'...
    };
nbpics = size(bpics, 2);
nlpics = size(lpics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

%must be odd!
SAMP_COL_LEN = 31;
SAMP_ROW_LEN = 31;

%model
%y=output
%x=real
%y=aax^2+ax+b1+b2+b3;
aa = zeros(2, PIC_MAX_COL);
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
    tmp_para = polyfit(x_list_u(:, i), y_list_u(:, i), 2);
    aa(1, i) = tmp_para(1);
    a(1, i) = tmp_para(2);
    b3(1, i) = tmp_para(3);
%     tmp_para = createFit(x_list_u(:, i), y_list_u(:, i));
%     aa(1, i) = tmp_para.p1;
%     a(1, i) = tmp_para.p2;
%     b3(1, i) = tmp_para.p3;
    tmp_para = polyfit(x_list_d(:, i), y_list_d(:, i), 2);
    aa(2, i) = tmp_para(1);
    a(2, i) = tmp_para(2);
    b3(2, i) = tmp_para(3);
%     tmp_para = createFit(x_list_d(:, i), y_list_d(:, i));
%     aa(2, i) = tmp_para.p1;
%     a(2, i) = tmp_para.p2;
%     b3(2, i) = tmp_para.p3;
    if(mod(i,100) == 0)
        fprintf('%d/%d\n',i,PIC_MAX_COL);
    end
end

%save
save('DSNU_31_2.mat','aa','a','b1','b2','b3');

if(1)
    ax = x_list_u(:,1736);
    ay = y_list_u(:,1736);
    plot(x_list_u(:,1736),y_list_u(:,1736) + b1(1,1736) + b2 ,'+');
    hold on;
    x = 0:5000:50000;
    y = polyval([aa(1,1736),a(1,1736),b1(1,1736) + b2 + b3(1,1736)],x);
    plot(x,y);
end

