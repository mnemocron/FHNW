%******************************************************************************
% \details     : AET2 Aufgabe 4-75
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_75.m
% \date        : 21.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng
w0 = 2*pi*10e6;
Q = 150;

syms L C Rs
assume(L, 'positive')
assume(C, 'positive')

anss = solve(w0 == 1/(L*C), Q == 1/Rs*sqrt(L/C), Q == w0*L/Rs)

%%
Ls = anss.L
Rss = anss.Rs



