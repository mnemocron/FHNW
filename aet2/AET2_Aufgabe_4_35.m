%******************************************************************************
% \details     : AET2 Aufgabe 4-35
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_35.m
% \date        : 21.03.2018
% \version     : 1.0
%******************************************************************************

clear; clc; close all;

R = 10;
L = 10e-6;
C = 40e-12;
w = 50.01e6;
U = 5+0*j;

%%
clc;
Z1 = par(j*w*L, R+1/(j*w*C));
Z1_=strcat("Z1 = ", num2str(abs(Z1)), "Ohm /_ ", num2str(rad2deg(angle(Z1))), "°")

Itot = U/Z1;
I_=strcat("I = ", num2str(abs(Itot)), "A /_ ", num2str(rad2deg(angle(Itot))), "°")

I1 = U/(R+1/(j*w*C));
I1_=strcat("I1 = ", num2str(abs(I1)), "A /_ ", num2str(rad2deg(angle(I1))), "°")

I2 = U/(j*w*L);
I2_=strcat("I2 = ", num2str(abs(I2)), "A /_ ", num2str(rad2deg(angle(I2))), "°")

S = U*Itot;
P = real(S)

WLmax = 1/2 * L * abs(Itot)
