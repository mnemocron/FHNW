

%%
clear all; clc;
format shorteng;

phim = 0;
I0m = 1.641 * 1000;

sphi = 0.5;
sim = 82.5;
sis = 4.46;



s1 = I0m*pi/180 * tan(pi/180*I0m) * sec(pi/180*I0m) * sphi

s2 = 1/(cos(pi/180*I0m)) * sim

s3 = 1/(cos(pi/180*I0m)) * sis


sqrt(s1^2 + s2^2 + s3^2)
