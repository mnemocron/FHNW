%**************************************************************************
% \details     : Test der Fitfunktion für E4.3
% \autor       : Simon Burkhardt
% \file        : glal4_phys_e4_3_fit_test.m
% \date        : 16.03.2019
% \version     : 1.0
%**************************************************************************

clear all; clc; format shorteng

mu0 = pi*4e-7;
N = 6*79;
len = 0.068;
I = 0.6;
R = (28e-3)/2;
z0 = -0.04;

z = linspace(-0.5, 0.5, 1e3);


B = @(z) (mu0 .* N .* I)./len  .* 1./2.*( ( (len./2 + (z-z0))./sqrt( (len./2+(z-z0)).^2 + R.^2) ) ...
    + ( (len./2 - (z-z0))./sqrt( (len./2-(z-z0)).^2 + R.^2) ) );

% für QTiPlot:
% (mu0 * N * I)/len  * 1/2*( ( (len/2 + (x-z0))/sqrt( (len/2+(x-z0))^2 + R^2) ) + ( (len/2 - (x-z0))/sqrt( (len/2-(x-z0))^2 + R^2) ) )

Bz = B(z);


% Messwerte
% zm = [-0.1   0   0.1   0.2   0.3   0.4   0.5];
% Bzm = [0.003  0.011  0.017 0.028  0.06  0.012  0.008 ];


plot(z, Bz); grid on; hold on;
% plot(zm, Bzm);
xlabel('[Distanz z] m')
ylabel('[magnetische Feldstärke B] T')
plot([0 z0], [0.01 0.01], 'r')
legend('B-Feld theoretisch', 'B-Feld gemessen', 'z-offset')


%%
clear all; clc;

x = linspace(0, 200e-3, 1e3);
% Spule
mu0 = pi*4e-7;
N = 2000;
l = 0.2;
I = 0.7;
R = (28e-3)/2;
z0 = 0.2;

% Magnet
Br = -1e-3;
d = 6e-3;
A = (d/2)^2*pi;
ll = 13e-3;

B = @(z) (mu0 .* N .* I)./l  .* 1./2.*( ( (l./2 + (z-z0))./sqrt( (l./2+(z-z0)).^2 + R.^2) ) ...
    + ( (l./2 - (z-z0))./sqrt( (l./2-(z-z0)).^2 + R.^2) ) );

F = Br./mu0.*A.*( B(x) - B(x+ll) );

plot(x, F);










