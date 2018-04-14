
%******************************************************************************
% \details     : Description
% \autor       : Simon Burkhardt
% \file        : AET2_Formel_2_Bauelemente.m
% \date        : 14.04.2018
% \version     : 1.0
%******************************************************************************
clear all; clc;
%******************************************************************************
% Eingabeparameter
% Diese variieren von Aufgabe zu Aufgabe
%%
pmin=-10;
pmax=40;
U=100;
f=10e3;
w=2*pi*f;

U_=100*exp(0);


%******************************************************************************
% Berechnungen
%%
P=1/2*(pmax+pmin)
cosdphi=((pmax+pmin)/(pmax-pmin))
phibe=acos(cosdphi);    % rad
rad2deg(phibe)          % deg

Q = j*sqrt(-pmin*pmax) % 1. Variante
Q = P*j*tan(phibe)     % 2. Variante
S_=P+Q
Y_=(S_/U^2)'
Z_=1/Y_


%******************************************************************************
% Elemente berechnen
%%
%   1. R + L
%Rs=(U^2)/P
Rs=real(Z_);
Xls=-imag(Z_');
Ls=Xls/(w);
Zrsl_=Rs+j*w*Ls;
strcat("R + L: ", num2str(Rs), " Ohm + ", num2str(Ls), " H") 
%   2. R + C
Rs=Rs;
Xcs=imag(Z_);
Cs=1/(w*Xls);
Zrsc_=Rs+1/(j*w*Cs);
strcat("R + C: ", num2str(Rs), " Ohm + ", num2str(Cs), " F") 

%   3. R || L
Gp=real(Y_);
Rp=1/Gp;
Blp=-imag(Y_);
Lp=1/(w*Blp);
Zrpl_=par(Rp, j*w*Lp);
strcat("R || L: ", num2str(Rp), " Ohm + ", num2str(Lp), " H") 

%   4. R || C
Rp=1/Gp;
Bcp=Blp;
Cp=Bcp/(w);
Zrpc_=par(Rp, 1/(j*w*Cp));
strcat("R || C: ", num2str(Rp), " Ohm + ", num2str(Cp), " F") 

%    Kontrolle
Srpc_ = U^2/Zrpc_'
Srpl_ = U^2/Zrpl_'
Srsc_ = U^2/Zrsc_'
Srsl_ = U^2/Zrsl_'


%******************************************************************************

