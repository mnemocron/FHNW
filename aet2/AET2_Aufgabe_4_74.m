%******************************************************************************
% \details     : AET2 Aufgabe 4-74
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_74.m
% \date        : 15.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

L = 2e-3;
C = 8e-9;
Rp = 2.5e3;

w0 = 1/sqrt(L*C)
Q = w0*C*Rp

syms wr
Z_ = j*wr*L + 1/(1/(Rp) + j*wr*C)

assume(wr, 'positive');
wrs = solve(imag(Z_) == 0)
double(wrs)

ans = strcat('wr = ', num2str(double(wrs/w0)), ' x w0')

%%
L = 2e-3;
C = 8e-9;
Rs = 1/Q * sqrt(L/C)   % 100 R

Qs = 1/Rs * sqrt(L/C)
w0s = 1/sqrt(L*C)

s = tf('s')
H1 = s*L + 1/( 1/Rp + 1/(s*C))
H2 = s*L + Rs + 1/(s*C)

nyquist(H1)
hold on
nyquist(H2)
% ist das richtig ?



