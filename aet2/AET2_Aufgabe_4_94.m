%******************************************************************************
% \details     : AET2 Aufgabe 4-94
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_94.m
% \date        : 20.06.2018
% \version     : 1.0
%******************************************************************************
% BEI DEN REAKTANZEN jeweils ABS und *J nicht vergessen !!!!!!!!
%******************************************************************************
clear all; clc
format shorteng

Rq = 300;
C = 470e-12;
f0 = 1e6;  w = 2*pi*f0;

Xc = 1/(w*C);
Rl = Xc^2/Rq + Rq

X4 = -1/sqrt( 1/Rl*(1/Rq - 1/Rl) );
L = abs(X4)/w

% aufschneiden an der Quelle
Zll = 1/(j*w*C) + par( j*w*L, Rl )  % == Rq
% aufschneiden an der Last
Zqq = par(Rq + 1/(j*w*C), j*w*L)    % == Rl



