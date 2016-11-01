close all;
clear;    

load('w_map_2000_51200_0.2_0.5_27.mat')
w1 = imresize(w,0.1);
[xx,yy]=meshgrid(1:1:205, 1:1:205);
meshz(xx,yy,w1);
set(gca,'xscale','log');
set(gca,'yscale','log');