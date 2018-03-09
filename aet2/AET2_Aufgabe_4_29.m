%******************************************************************************
% \details     : AET2 Aufgabe 4-31
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_31.m
% \date        : 09.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;

%%
% 4-29
clear; clc;

% U=230V I=10A Pr=1500W
U=230*exp(j*0);
P=1500;
S=10*230        % 230V * 10A

%%
pmax=P+S
pmin=P-S

% Leistungsfaktor cos(phi)
cosphi=(pmax+pmin)/(pmax-pmin)
d_phi=acosd(cosphi)


f=50; w=2*pi*f; t=linspace(0, 2/f, 1e4);
uu=230*sqrt(2)*sin(w*t);
ii=10*sqrt(2)*sin(w*t + deg2rad(d_phi));
p=uu.*ii;

%%
% Kontrolle
hold on;
plot(t, uu, "blue");
plot(t, ii*5, "red");
plot(t, p, "green");
abs(max(p)-pmax) < 1e-3
abs(min(p)-pmin) < 1e-3

%%
I=10*exp(j*d_phi);
Z=U/I
% 12.9793e+000 + 18.9878e+000i
% 12.9793e+000 - 18.9878e+000i

% Kontrolle
Z = 12.9793e+000 + 18.9878e+000i;       % ohmsch - (induktiv/kapazitiv)?
abs(U/Z)
abs(I*Z)
Z = 12.9793e+000 - 18.9878e+000i;       % ohmsch - (kapazitiv/induktiv)?
abs(U/Z)
abs(I*Z)

