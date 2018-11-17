%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_7_mehrdimmensional.m
% \date        : 17.11.2018
% \version     : 1.0
%******************************************************************************

%% Aufgabe 2
% a)
clear all; close all; clc; format shorteng

[X Y] = meshgrid(-5:0.1:5);
Z = X+Y-1;
contour(X,Y,Z, -3:1:3);
grid on

%%
% b)
clear all; close all; clc; format shorteng

[X Y] = meshgrid(-10:0.1:10);
Z = X.*Y;
contour(X,Y,Z, [-9 -4 -1 0 1 4 9]);
grid on


%% Aufgabe 3
% a)
clear all; close all; clc; format shorteng

[X Y] = meshgrid(-3:0.1:3);
Z = (4.*X.^2+Y.^2).*exp(-X.^2-Y.^2);
subplot(2,1,1);
mesh(X,Y,Z);
subplot(2,1,2);
contour(X,Y,Z,10);
grid on


%%
% b)
clear all; close all; clc; format shorteng

[X Y] = meshgrid(-1:0.01:1);
Z = Y.^2-Y.^4-X.^2;
subplot(2,1,1);
mesh(X,Y,Z);
subplot(2,1,2);
contour(X,Y,Z,20);
grid on

%%
% c)
% b)
clear all; close all; clc; format shorteng

x = -2*pi:0.1:2*pi;
y = -2:0.1:2;
[X Y] = meshgrid(x,y);
Z = exp(-Y).*cos(X);
subplot(2,1,1);
mesh(X,Y,Z);
subplot(2,1,2);
contour(X,Y,Z,20);
grid on



