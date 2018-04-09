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

% P = abs(I)^2 * real(Z)
%Itot=sqrt(P/Ze)         % 

Ubetrag = sqrt(P/real(Ze))
% ein Winkel MUSS angenommen werden !
phiU = 0;



% ACHTUNG !!!
% S=U*I' = Z*I*I'
% % % S=(Itot*Ze)*Itot'
% % % 
% % % % S=U*I'
% % % U=S/Itot';
% % % 
% % % Iz1=U/Z1;
% % % Iz2=U/Z2;

%%
% Kontrolle
Itot2=Iz1+Iz2
abs(Itot - Itot2) < 1e-3

%%
% Lösungen: 
% U = 11.85V
% phiU = 0
% Iz1 = 23° / Iz2 = 37°













