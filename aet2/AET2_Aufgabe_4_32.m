%******************************************************************************
% \details     : AET2 Aufgabe 4-32
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_32.m
% \date        : 09.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;

%%                     R2
%        R1       ---|===|----  
% o----|===|-----|            |-----o
%                 ---uuuuu----
%                      L

RDC=10;         % Ohm

% Messung bei
f=1e6;          % Hz
I=2;
P=143.3;        % W
Q=197.25*j;     % VAr
w=2*pi*f;

%%
% S=P+Q;
R1=RDC          % Weil Spule = Kurzschluss
P1 = I^2*R1     % 40W
P2 = P-P1       % 103.3W

S2 = P2+Q
% S = abs(I)^2 * Z  = abs(I)^2 / Y
Y=abs(I)^2 / S2

R2 = 1/real(Y)          % 120 Ohm
% Yl = 1/(j*w*L)
L = 1/(imag(Y)*j*w)     % 10m uH

% Fall: Serieschaltung

Z2 = 1/Y
R2 = real(Z2)       % 25 Ohm
L = imag(Z2)/w      % 7.85 uH

%%
% Kondensator
% C = 2.53 nF

