%******************************************************************************
% \details     : AET2 Aufgabe 4-66
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_66.m
% \date        : 12.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

C = 50e-12;
Qc = 250;
L = 0.4e-6;
Ql = 120;

f = 35e6;
w = 2*pi*f;

Qtot = par(Ql, Qc)

Rs = 1/Qtot *sqrt(L/C)
Rp = Qtot / sqrt(C/L)

fres = 1/(2*pi*sqrt(L*C))   % stimmt nicht genau !!!!