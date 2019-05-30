%**************************************************************************
% \details     : digitale Signalverarbeitung - Pseudoprueffung 2
% \autor       : Simon Burkhardt
% \file        : dsvgl_pseudoprueffung_2.m
% \date        : 20.05.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;

Ts = 1;
fs = 1/Ts;

fg = fs/4;
ht = @(t) 2.*fg.* sin( 2.*pi.*fg.*t ) ./ (2.*pi.*fg.*t);
k = -3:3;

hk = Ts.*ht(k.*Ts +eps);

fvtool(hk)


%%
% Aufgabe 2
clear; clc;

syms A B
Y4 = [4*B, -j*2*A, 0, j*2*A];

ifft(Y4)



