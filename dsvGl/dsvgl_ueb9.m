%**************************************************************************
% \details     : digitale Signalverarbeitung - Uebung 9
% \autor       : Simon Burkhardt
% \file        : dsvgl_ueb9.m
% \date        : 13.05.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;


% todo - Integral: h(t) = H(f) * exp(j 2pi t)















%%

fs = 9.6;
fg = 1;

k = -30:30;
k = k+eps;    % Verschieben für Mittelwert

ht = @(t) (sin(pi .* fs .* t) - sin(2.*pi.*fg .* t))./(pi .* t);

hk = ht( k./fs );

stem(k, hk)

%%
L = length(k)

% verschieben um 30 Werte
verschieben = (L-1)/2

%%
hk = hk./fs;
handle = fvtool(hk)
set(handle, 'FrequencyRange', '[-pi, pi)')

%%
w = hamming(61);
hkw = hk.*w';
stem(w);

%%
handle = fvtool(hk, 1, hkw, 1)
set(handle, 'FrequencyRange', '[-pi, pi)')



%%
%**************************************************************************