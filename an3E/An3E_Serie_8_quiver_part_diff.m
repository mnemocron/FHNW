%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_8.m
% \date        : 24.11.2018
% \version     : 1.0
%******************************************************************************

%%
% Aufgabe 3)
clear all; close all; clc
format shorteng

subplot(2,2,1);
[x,y] = meshgrid(-3:1:3,-3:1:3);
px = (x.*0 + 1/2);
py = (y./3);
quiver(x,y,px,py); grid on; axis equal;
title('a)')

subplot(2,2,2);
[x,y] = meshgrid(-3:1:3,-3:1:3);
px = (x.*0 - 1/3);
py = (y./3);
quiver(x,y,px,py); grid on; axis equal;
title('b)')

subplot(2,2,3);
[x,y] = meshgrid(-3:1:3,-3:1:3);
px = (x./2);
py = (y./2);
quiver(x,y,px,py); grid on; axis equal;
title('c)')

subplot(2,2,4);
[x,y] = meshgrid(-3:1:3,-3:1:3);
px = (1 + x - y)./5;
py = (1 + y - x)./5;
quiver(x,y,px,py); grid on; axis equal;
title('d)')

%%
% Aufgabe 7)
clear all; close all; clc
format shorteng
syms x y

f = sqrt(log(x^2+1)+exp(2*x)*cos(y));

fx = diff(f, x, 1);
pretty(simplify(fx))
fy = diff(f, y, 1);
pretty(simplify(fy))

gradient(f, [x,y])

%%
% Aufgabe 8)
% a)
clear all; close all; clc
syms x y

P = [1, -3];
z = log(2*x+exp(3*y));

fx = diff(z, x, 1);
pretty(simplify(fx));
fx = subs(fx, [x, y], P);
double(fx)

fy = diff(z, y, 1);
pretty(simplify(fy));
fy = subs(fy, [x, y], P);
double(fy)

%% b)
clear all; close all; clc
syms s t

P = [-4, 7];
r = atan((s*t+1)/(s+t));
fs = diff(r, s, 1)
fs = subs(fs, [s, t], P);
double(fs)

ft = diff(r, t, 1)
ft = subs(ft, [s, t], P);
double(ft)

%% c)
clear all; close all; clc
syms x y

P = [0.5 1];
z = log(cos(4*x^3-2*y^2+1));

fx = diff(z, x, 1);
pretty(simplify(fx));
fx = subs(fx, [x, y], P);
double(fx)

fy = diff(z, y, 1);
pretty(simplify(fy));
fy = subs(fy, [x, y], P);
double(fy)

%% d)
clear all; close all; clc
syms x1 x2 x3 x4

P = [pi, pi, 2*pi, 2*pi];
y = 4*sin(x1^2 + x2^2 + x3^2 + x4^2)^3;

fx1 = diff(y, x1, 1);
pretty(simplify(fx1));
fx1 = subs(fx1, [x1, x2, x3, x4], P);
double(fx1)

fx2 = diff(y, x2, 1);
pretty(simplify(fx2));
fx2 = subs(fx2, [x1, x2, x3, x4], P);
double(fx2)

fx3 = diff(y, x3, 1);
pretty(simplify(fx3));
fx3 = subs(fx3, [x1, x2, x3, x4], P);
double(fx3)

fx4 = diff(y, x4, 1);
pretty(simplify(fx4));
fx4 = subs(fx4, [x1, x2, x3, x4], P);
double(fx4)




















