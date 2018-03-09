%******************************************************************************
% \details     : AET2 Aufgabe 4-31
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_31.m
% \date        : 09.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;

%%
Z1=120+50*j;
Z2=80-60*j;
P=2.12+0*j;

%%

Ze=1/((1/Z1)+(1/Z2));   % Gesamtimpedanz

Itot=sqrt(P/Ze)         % 

% ACHTUNG !!!
% S=U*I' = Z*I*I'
S=(Itot*Ze)*Itot'

% S=U*I'
U=S/Itot';

Iz1=U/Z1;
Iz2=U/Z2;

%%
% Kontrolle
Itot2=Iz1+Iz2
abs(Itot - Itot2) < 1e-3

%%













