%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_VossMcCartney_PinkNoise.m
% \date        : 07.11.2019
% \version     : 1.0
%******************************************************************************
% https://www.dsprelated.com/showarticle/908.php

% Definition von Pink Noise
% Rauschen mit Rauschleistungsdichte von -10 dB/Dekade (-3dB/Oktave)
% vgl. rotes/braunes Rauschen: -20 dB/Dekade (-6dB/Oktave)

clear all; clc;
format shorteng;

N = 1024;

x1 = randn(1, N);
x2 = randn(1, N/2);
x3 = randn(1, N/4);
x4 = randn(1, N/8);
x5 = randn(1, N/16);
x6 = randn(1, N/32);
x7 = randn(1, N/64);
x8 = randn(1, N/128);

x = x1;

for t=1:N
    x(t) = x2(ceil(t/2)) + x3(ceil(t/4)) + x4(ceil(t/8)) + x5(ceil(t/16)) + x6(ceil(t/32)) + x7(ceil(t/64)) + x8(ceil(t/128));
end


pxx = pwelch(x);
semilogx(10*log10(pxx));
grid on
hold on

% Vergleich mit x1 (white noise) zeigt,
% dass beim Pink Noise vor allem die tiefen Frequenzanteile 
% in der Amplitude verstärkt sind
pyy = pwelch(x1);
semilogx(10*log10(pyy));

