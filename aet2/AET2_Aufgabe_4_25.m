%******************************************************************************
% \details     : AET2 Aufgabe 4-25
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_25.m
% \date        : 16.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;
format shorteng

%%
Z1 = (2+j*2)*1e3;
Z2 = (-5*j)*1e3;
Z3 = (j*3)*1e3;
Z4 = 6e3;

I1 = -(10e-3)*exp(j*deg2rad(-45));
%I1 = -0.01*exp(-j*pi/4);
U3 = 5*j;

%%
Zq = 1/(1/(Z1+Z2) + 1/Z3 + 1/Z4);
Zersatz = strcat(num2str(abs(Zq)), " Ohm /_", num2str(rad2deg(angle(Zq))), "°") % 2971.5633 Ohm /_17.7447° Stimmt

%%
Ue1 = I1*Z1;        % Stromquelle zu Spannungsquelle
Ze12 = Z1 + Z2;     % zusätzliche Impedanz addieren

Ie12 = Ue1 / Ze12;  % zurück zur Stromquelle
Ie3 = U3 / Z3;      % j5V zu Stromquelle
Ze123 = par(Ze12, Z3);
Ie123 = Ie3 + Ie12; 
Iersatz=strcat(num2str(abs(Ie123)), " A /_", num2str(rad2deg(angle(Ie123))), "°")

Ze = par(Ze123, Z4);
Uq = Ie123*Zq;
Uersatz=strcat(num2str(abs(Uq)), " V /_", num2str(rad2deg(angle(Uq))), "°") % stimmt




