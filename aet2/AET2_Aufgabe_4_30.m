%******************************************************************************
% \details     : AET2 Aufgabe 4-30
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_30.m
% \date        : 09.03.2018
% \version     : 1.0
%******************************************************************************
clear; clc; close all;

%%
% (R + L) || C
R=10.56;
Xl=0+j*14.08;
Xc=0-j*35.2;
U=220*exp(j*0);

%%
Zrl=R+Xl;
Il=U/Zrl;
IIl=strcat(num2str(abs(Il)), "A /_ ", num2str(rad2deg(angle(Il))), "°")

Ic=U/Xc;
IIc=strcat(num2str(abs(Ic)), "A /_ ", num2str(rad2deg(angle(Ic))), "°")

I=Ic+Il;
II=strcat(num2str(abs(I)), "A /_ ", num2str(rad2deg(angle(I))), "°")

% Kontrolle
% Ze=1/((1/Zrl)+(1/Xc));
% IIs=U/Ze;
% II=strcat(num2str(abs(I)), "A /_ ", num2str(rad2deg(angle(I))), "°")

P=abs(Il^2*R)
Ql=abs(Il)^2*Xl
Qc=abs(Ic)^2*Xc
Q=Qc+Ql

Spq=abs(P)+j*abs(Q)     % aus Blind + Wirkleistung
Sui=U*I'                % aus Spannung * Strom
% Sui=abs(U)*abs(I)*cos(angle(U)-angle(I)) + j*abs(U)*abs(I)*sin(angle(U)-angle(I))
%%







