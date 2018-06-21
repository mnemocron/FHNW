%******************************************************************************
% \details     : AET2 Aufgabe 4-62
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_62.m
% \date        : 12.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc

L = 10e-6;
Rs = 0.8;
f = 2e6;
w = 2*pi*f;
Qtot = 100;

Ql = w*L/Rs

Qc = 1/( 1/Qtot - 1/Ql )

% fres = 1/ 2pi sqrt(LC)
C = (1/(2*pi*f))^2/L
Rp = Qc/(w*C)


% Kontrolle
% Qc = w*C*Rp
% Qtot = par(Qc, Ql)
% fres = 1/(2*pi*sqrt(L*C))

