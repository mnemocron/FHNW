%******************************************************************************
% \details     : AET2 Aufgabe 4-86
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_86.m
% \date        : 22.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

s=tf('s')

Rs=10;
L=10e-6;
C=10e-9;

X=sqrt(L/C)
Q=X/Rs

w0 = 1/sqrt(L*C)
wr = w0*sqrt(1-1/Q^2)
fr = wr/2/pi

Rp = L/C * 1/Rs;

Zs = 1/( s*C + 1/(Rs+s*L) );
Zp = 1/( s*C + 1/Rp + 1/s*L );

nyquist(Zs, Zp)



