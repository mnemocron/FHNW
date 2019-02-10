%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_9.m
% \date        : 01.12.2018
% \version     : 1.0
%******************************************************************************
%%
% Aufgabe 1)
clear all; close all; clc
format shorteng

R = 80.5;
I = 6.2;
sr = 1;
si = 0.1;

sqrt( (2*R*I*si)^2 + (I^2*sr)^2 )
%%
% Aufgabe 4)
clear all; close all; clc
format shorteng
syms x y z

f = exp(x*y)*cos(3*x+y);
fx = diff(f, x, 1);
pretty(simplify(fx))
fy = diff(f, y, 1);
pretty(simplify(fy))

fxx = diff(fx, x, 1);
pretty(simplify(fxx))
fyy = diff(fy, y, 1);
pretty(simplify(fyy))

fxy = diff(fx, y, 1);
pretty(simplify(fxy))
fyx = diff(fy, x, 1);
pretty(simplify(fyx))

%%
clear all; close all; clc
format shorteng
syms x y z
f = exp(x*y)*cos(3*x+y);
x0 = 1; 
y0 = 0;
z0 = subs(f, [x y], [x0 y0]);
fx = diff(f, x, 1);
fy = diff(f, y, 1);
f_Ebene = z - z0 == subs(fx, [x y], [x0 y0])*(x-x0) ...
    + subs(fy, [x y], [x0 y0])*(y-y0)

%%
% Aufgabe 5)
clear all; close all; clc
format shorteng
syms x y z
f = x^3 + 2*x*(y-1) -y^2;
x0 = 1; 
y0 = 2;
z0 = subs(f, [x y], [x0 y0]);
fx = diff(f, x, 1);
fy = diff(f, y, 1);
f_Ebene = z - z0 == subs(fx, [x y], [x0 y0])*(x-x0) ...
    + subs(fy, [x y], [x0 y0])*(y-y0)


%%
% Aufgabe 6) f)
clear all; close all; clc
format shorteng
syms x y z
f = (y^2 - x^2)*exp(-(x^2+y^2)/2);
fx = diff(f, x, 1);
fy = diff(f, y, 1);
fxx = diff(fx, x, 1);
fyy = diff(fy, y, 1);
lsg.x = solve(fx == 0, x);
lsg.y = solve(fy == 0, y);
fxlsg = subs(fx, x, lsg.x);
fylsg = subs(fy, y, lsg.y);
nul = solve(fxlsg == fylsg, [x y]);
% z = subs(f, [x y], [nul.x nuul.y])
fxxs = subs(fxx, [x y], [nul.x nul.y]);  % < 0
fyys = subs(fyy, [x y], [nul.x nul.y]);  % > 0

subs(fx, [x y], [0, sqrt(2)])
subs(fy, [x y], [sqrt(2), 0])
% sorry, i chegges nid











