%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_2.8.14_HammingWelch.m
% \date        : 09.11.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

fs = 8192;
tr = 8;    % Aufnahmezeit
Q = fs * tr;

% a)
p = ceil( log2( 1.3/12 *fs) )
N = 2^p
% Kontrolle
1.3 * fs/(2^p)   % 10.4 Hz Frequenzauflösung

% b)
D = N/2;        % Segment Overlap (50%)
M = (Q-N)/D + 1 % Anzahl Segmente

%%
clear all; clc
% c)
% Macht es Sinn mit 16.384 kHz abzutasten?
fs = 16384;
tr = 8;    % Aufnahmezeit
Q = fs * tr;
p = ceil( log2( 1.3/12 *fs) )
N = 2^p
1.3 * fs/(2^p)  % 10.4 Hz Frequenzauflösung
D = N/2;        % Segment Overlap (50%)
M = (Q-N)/D + 1 % Anzahl Segmente

% macht nicht Sinn
% Frequenzauflösung bleibt gleich (10.4Hz)
% FFT Länge verdoppelt sich von 1024 auf 2048
% oder anders,
% in dem die Bandbreite vergrössert wird
% analysiert man im Frequenzbereich eine Menge "Leerraum"




