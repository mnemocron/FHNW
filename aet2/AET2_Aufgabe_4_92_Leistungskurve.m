%******************************************************************************
% \details     : AET2 Aufgabe 4-92
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_92_Leistungskurve.m
% \date        : 19.06.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

Rq = 10;
Xq = 20;

Zq_ = Rq + j*Xq;

U = 1;

Rl = linspace(0, 10*Rq, 1e3);
P = (U./(Rl+Zq_)).^2 .* Rl;

plot(Rl, P);

%%
clear all; clc

Rq = 10;

U = 1;
Rl = linspace(0, 10*Rq, 1e3);
P = (U./(Rl+Rq)).^2 .* Rl;
plot(Rl, P);




