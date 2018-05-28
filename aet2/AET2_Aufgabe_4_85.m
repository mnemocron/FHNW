%******************************************************************************
% \details     : AET2 Aufgabe 4-85
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_85.m
% \date        : 22.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

Rs = 6; Rp = 12; L=0.004; C=20e-6;

s=tf('s');
Z = 1/( 1/Rp + s*C + 1/(Rs+s*L) );
Y = 1/Z;
nyquist(Z, Y);



Zp= 1/( s*C + 1/(Rs+s*L) );