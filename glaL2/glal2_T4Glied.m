%******************************************************************************
% \details     : Description
% \autor       : Simon Burkhardt
% \file        : glaL2_T4Glied.m
% \date        : 08.03.2018
% \version     : 1.0
%******************************************************************************
clc; close all; close all hidden; clear variables;

%%
%------------------------------------------------------------------------------
% Variablen
%------------------------------------------------------------------------------
U=48;
Rq=3;
R1=1;
R2=24;
R3=2;
Rl=[0 1 6 10 14 22 38 46 70 Inf]';

%%
%------------------------------------------------------------------------------
% Berechnung
%------------------------------------------------------------------------------

Re=R1+1./((1./(R3+Rl))+(1/R2));
Ge=1./Re;
I1=U./(Rq+Re);
U1=I1.*Re;
I2=(U1-I1*R1)./(R3+Rl);
% U2=I2.*Rl;

I3=I1-I2;
U2=I3.*R2-I2.*R3;
P1=U1.*I1;
P2=U2.*I2;
eta=P2./P1;

T = table(Rl, Re, Ge, I1, I2, I3, U1, U2, P1, P2, eta);
T(1:length(Rl),:)

%%
%------------------------------------------------------------------------------
% ENDE
%------------------------------------------------------------------------------