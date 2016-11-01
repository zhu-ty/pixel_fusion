clear;
close all;

areaLU = [816,435];%x,y => col,row
areaRD = [1911,909];%x,y => col,row
pics = {'(1).tif','(2).tif','(3).tif','(4).tif'};

npics = size(pics, 2);
narea_col = areaRD(1) + 1 - areaLU(1);
narea_row = areaRD(2) + 1 - areaLU(2);

ptsi = zeros(npics * narea_row, narea_col);
ptso = zeros(npics, 1);
para = zeros(2, narea_col);

avg = zeros(1,npics);

for i = 1:npics
    pic = pics{i};
    I = imread(pic);
    Ip = I(areaLU(2):areaRD(2),areaLU(1):areaRD(1));
    avg(1,i) = mean(mean(Ip));
    for j = 1:narea_col
        ptsi((i - 1) * narea_row + 1 : i * narea_row, j) = Ip(:, j);
        ptso(i, 1) = round(avg(1,i));
    end
end

%ptso = repmat(ptso,1,narea);
ptso = kron(ptso,ones(narea_row,1));

for i = 1:narea_col
    para(:,i) = polyfit(ptsi(:,i),ptso(:,1),1);
end

for i = 1:npics
    pic = pics{i};
    I_ = imread(pic);
    %Ip = I(areaLU(2):areaRD(2),areaLU(1):areaRD(1));
    %avg = mean(mean(Ip));
    for j = 1:size(I_, 2)
        if(j >= areaLU(1) && j <= areaRD(1))
            %I_(:,j) = para(1, j - areaLU(1) + 1) * I_(:,j) + para(2, j - areaLU(1) + 1);
            I_(:,j) = 1 * I_(:,j) + para(2, j - areaLU(1) + 1);
        end
    end
    imwrite(I_, ['p_b_',pic]);
end

if(1)
    plot(ptsi(:,1),ptso(:,1),'+');
    hold on;
    x = 0:5000:50000;
    y = polyval(para(:,1),x);
    plot(x,y);
end