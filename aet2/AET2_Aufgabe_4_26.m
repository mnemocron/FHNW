%******************************************************************************
% \details     : AET2 Aufgabe 4-26
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_26.m
% \date        : 13.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;
format shorteng

%%
Z1 = 20+j*10;
U1 = 20;
Z2 = 50+50*j;
U2 = -(0-40*j);
Z3 = 40-j*10;
I3 = 1*exp(j*deg2rad(30));
Z4 = 10-j*40;
U4 = -(20-j*30);
Z5 = 10+10*j;

%%
% Z12 = 1/((1/Z1) + (1/Z2));
Z12 = par(Z1, Z2);
Z123 = Z12 + Z3;
% Z1234 = 1/( (1/Z123) + (1/Z4) );
Z1234 = par(Z123, Z4);
Ze = Z1234 + Z5
strcat(num2str(abs(Ze)), " Ohm /_", num2str(rad2deg(angle(Ze))), "°") % stimmt

%%
Ie1 = U1/Z1;        % Ersatzstromquelle 1
Ie2 = U2/Z2;        % Ersatzstromquelle 2
Ie12 = Ie1 + Ie2;   % Z = Z12
Ue12 = Ie12*Z12;    % in Spannungsquelle zusammenführen

Ue3 = I3*Z3;        % Ersatzspannungsquelle
Ue123 = Ue12 + Ue3; % Spannungsquellen addieren

Ie123 = Ue123/Z123 % daraus wieder die Stromquelle  --> stimmt so far
Ie4 = U4/Z4
Ie1234 = Ie123 + Ie4; % stimmt
strcat(num2str(abs(Ie1234)), " A /_", num2str(rad2deg(angle(Ie1234))), "°") % 

Ue1234 = Ie1234*(Ze-Z5)
strcat(num2str(abs(Ue1234)), " V /_", num2str(rad2deg(angle(Ue1234))), "°") % stimmt

