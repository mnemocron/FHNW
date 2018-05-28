%******************************************************************************
% \details     : AET2 Aufgabe 4-64
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_64
% \date        : 12.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

Qc = 250;
C = 50e-12;
f = 35e6;
w = 2*pi*f;

Rp = Qc/(w*C)
Rs = 1/(w*C*Qc)
