%**************************************************************************
% \details     : digitale Signalverarbeitung - Uebung 10
% \autor       : Simon Burkhardt
% \file        : dsvgl_ueb10.m
% \date        : 18.05.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;

fs = 20e3; Ts = 1/fs;
L = 21;

% Ausgangspunkt: Impulsantwort h(t) eines analogen Filters
wg = 2*pi*10e3;
% hs = @(s) 1./(s+wg);
ht = @(t) heaviside(t).*wg.*exp(-wg.*t);

k = -(L-1)/2:(L-1)/2;
f = k.*fs;
t = k.*Ts;

% hk = hs(j*2*pi*f);
hk = ht(t)











