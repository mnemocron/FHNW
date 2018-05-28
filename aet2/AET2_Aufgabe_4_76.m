%******************************************************************************
% \details     : AET2 Aufgabe 4-76
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_76.m
% \date        : 21.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

R=5;
L=1e-3;
C=12e-6;

syms w
Yfw = j*w*C + 1/(R+j*w*L)
assume(w, 'positive')
anss = solve(imag(Yfw) == 0)

%%
wr = double(anss)
fres = wr/(2*pi)

%%
s = tf('s')
Hy = s*C + 1/(R + s*L)
Hz = 1/Hy
nyquist(Hy, Hz)
