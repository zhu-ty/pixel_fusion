close all;
clear;    

load('w_map_ex2_2000_63000_0.5_0.5_29.5.mat')
w1 = imresize(w,0.1);
[xx,yy]=meshgrid(1:1:205, 1:1:205);
meshz(xx,yy,w1);
set(gca,'xscale','log');
set(gca,'yscale','log');