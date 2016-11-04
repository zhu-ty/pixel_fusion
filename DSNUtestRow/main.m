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

%must be even!
SAMP_COL_LEN = 30;
SAMP_ROW_LEN = 30;

%model
%y=output
%x=real
%y=aax^2+ax+b1+b2+b3;
aa = zeros(PIC_MAX_ROW, 1);
a = zeros(PIC_MAX_ROW, 1);
b1 = zeros(PIC_MAX_ROW, 1);
b2 = 0;
b3 = zeros(PIC_MAX_ROW, 1);

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
    b1(:, 1) = b1(:, 1) + mean(tmp_I, 2);
end
b1 = b1 / nbpics;

%cal a,b3
y_list = zeros(PIC_MAX_ROW, SAMP_COL_LEN * nlpics);
x_list = zeros(PIC_MAX_ROW, nlpics);


for i = 1 : nlpics
    tmp_I = imread(lpics{i});
    [x_list_i, y_list_i] = img_data_generator_row(tmp_I, b1, b2,...
        PIC_MAX_ROW, PIC_MAX_COL, SAMP_ROW_LEN, SAMP_COL_LEN);
    x_list(:, i) = x_list_i(:,:);
    y_list(:,(i - 1) * SAMP_COL_LEN + 1 : i * SAMP_COL_LEN) = y_list_i;
end

x_list = kron(x_list, ones(1, SAMP_COL_LEN));

%fitp = zeros(2, PIC_MAX_COL,2,2);

for i = 1 : PIC_MAX_ROW
    tmp_para = polyfit(x_list(i, :), y_list(i, :), 2);
    aa(i, 1) = tmp_para(1);
    a(i, 1) = tmp_para(2);
    b3(i, 1) = tmp_para(3);
%     tmp_para = createFit(x_list(i, :), y_list(i, :));
%     aa(i, 1) = tmp_para.p1;
%     a(i, 1) = tmp_para.p2;
%     b3(i, 1) = tmp_para.p3;
    if(mod(i,100) == 0)
        fprintf('%d/%d\n',i,PIC_MAX_ROW);
    end
end

%save
save('DSNU_ROW_30_2.mat','aa','a','b1','b2','b3');

if(1)
    ax = x_list(1736,:);
    ay = y_list(1736,:);
    plot(x_list(1736,:),y_list(1736,:) + b1(1736,:) + b2 ,'+');
    hold on;
    x = 0:5000:50000;
    y = polyval([aa(1736,1),a(1736,1),b1(1736,1) + b2 + b3(1736,1)],x);
    plot(x,y);
end

