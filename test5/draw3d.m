close all;
clear;
version = 2;

if(version == 1)
    load('w_map_2000_1600_0.2_0.5.mat')
    w1 = imresize(w,0.1);
    [xx,yy]=meshgrid(1:1:205, 1:1:205);
    meshz(xx,yy,w1);
elseif(version == 2)
    load('w_map_2000_1600_0.2_0.5.mat')
    w1 = imresize(w,0.1);
    [xx,yy]=meshgrid(1:1:205, 1:1:205);
    meshz(xx,yy,w1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
end
