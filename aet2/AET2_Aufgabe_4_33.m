%******************************************************************************
% \details     : AET2 Aufgabe 4-33
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_33.m
% \date        : 13.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;

S2b=1490;

Z1=2+3*j;
Z2=3+6*j;

Ze=1/((1/Z1)+(1/Z2));

% % laut Niklaus:
% I = sqrt(S2b*Z2)/abs(Ze)
% abs(I)

% eigene Lösung
Y2=1/Z2;
% S = abs(U)^2 * Y'
Ubetr = sqrt(S2b/Y2');
I = Ubetr/abs(Ze)
abs(I)

