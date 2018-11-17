%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Mehrdimmensionale_Analysis_Grundlagen.m
% \date        : 17.11.2018
% \version     : 1.0
%******************************************************************************

%% Grundlagen
clear all; close all; clc; format shorteng
% x-Koordinaten des Gitters
% in 1er schritten von -3 bis 3
x = -3:1:3;

% y-Koordinaten
y = -1:0.5:1;

% Erstellen eines Gitternetzes
[X Y] = meshgrid(x,y);
[X Y] = meshgrid(-10:0.5:10);

Z = 100 - X.^2 - Y.^2;
% mesh(X,Y,Z);
surf(X,Y,Z);
xlabel x
ylabel y
zlabel z

%% Beispiel S. 27
clear all; close all; clc; format shorteng

x = -2:0.1:2;
y = -2:0.1:2;
[X Y] = meshgrid(x, y);
Z = X.*exp(-X.^2-Y.^2);
surf(X,Y,Z);
xlabel x
ylabel y
zlabel z
colormap hot
%%
colormap parula
colormap jet
colormap hsv
colormap hot
colormap cool
colormap spring
colormap summer
colormap autumn
colormap winter
colormap gray
colormap bone
colormap copper
colormap pink
colormap lines

map = [1 1 0
       1 0.5 0
       1 0 0
       1 0 0.5
       0.5 0 0.5
       0.1 0 0.1
       0 0 0];
colormap(map)

% https://www.mathworks.com/matlabcentral/fileexchange/40318-build-custom-colormaps
[cmap] = buildcmap('kbry'); % black-blue-red-yellow
colormap(cmap)

%% Beispiel S. 34)
clear all; close all; clc; format shorteng

x = -6:0.1:6;
y = -5:0.1:5;
[X Y] = meshgrid(x, y);
Z = -X.^2+Y.^2-2.*Y;
contour(X,Y,Z, [-3 -2 -1 0 1]);
grid on
map = [0 0 0.7
    0 0.7 0
    0 0 0
    0.7 0 0
    0 0 0];
colormap(map)

%% Beispiel S. 35
clear all; close all; clc; format shorteng

x = -5:0.1:5;
y = -5:0.1:5;
[X Y] = meshgrid(x, y);
Z = sin(X)+2.*sin(Y);
contour(X, Y, Z);
%%
clear all; close all; clc; format shorteng

[X Y] = meshgrid(-5:0.1:5);
Z = sin(X)+2.*sin(Y);
surfc(X, Y, Z);