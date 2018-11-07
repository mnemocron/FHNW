%******************************************************************************
% \details     : Analogtechnik Simulationsprojekt
%                Dimensionierung Tiefpassfilter 4. Ordnung mit fg = 5kHz
% \autor       : Simon Burkhardt
% \file        : 
% \date        : 24.10.2018
% \version     : 1.0
%******************************************************************************
clear all; clc;
format shorteng

fg = 5e3;
A0 = -1;      % invertierender Verstärker

% Butterworth aus Tabelle
a = [1.8478, 0.7654];
b = [1.0000, 1.0000];

% Verhältnis C2/C1
c2faktor_1 = 4*b(1)/(a(1)^2)*(1-A0)
c2faktor_2 = 4*b(2)/(a(2)^2)*(1-A0)

% Wahl der C
% C2 = [22e-9, 100e-9];
% C1 = [1e-9, 1e-9];
C1 = [1e-9, 680e-12];
C2 = [3.3e-9, 12e-9];


R2_1 = ( a(1)*C2(1) - sqrt( (a(1)*C2(1))^2 -4*C1(1)*C2(1)*b(1)*(1-A0) ) ) / (4*pi*fg*C1(1)*C2(1));
R2_2 = ( a(2)*C2(2) - sqrt( (a(2)*C2(2))^2 -4*C1(2)*C2(2)*b(2)*(1-A0) ) ) / (4*pi*fg*C1(2)*C2(2));
R2 = [R2_1, R2_2];

R1 = [R2_1/(-A0), R2_2/(-A0)];

R3_1 = b(1) / (4*pi^2*fg^2*R2(1)*C1(1)*C2(1));
R3_2 = b(2) / (4*pi^2*fg^2*R2(2)*C1(2)*C2(2));
R3 = [R3_1, R3_2];

% resultate ausgeben
C1
C2
R1
R2
R3


