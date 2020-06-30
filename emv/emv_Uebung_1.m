%******************************************************************************
% \details     : EMV 
% \autor       : Simon Burkhardt
% \file        : emv_Uebung_1.m
% \date        : 27.02.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;
d = 1e-3;   % m
r = d/2;
% Strom
I1 = 10;     % 10 A
tr = 50e-9;  % 50 ns
di_dt = I1/tr

% Leiterabschnitt
L = 100e-3;
% Rechtecke
L = L;
B = 20e-3;

% a)
% unendlicher Leiter --> Baustein 1
a1 = 4e-3 + r;
b1 = 4e-3 + 20e-3 -r;
c1 = L - 2*r;

% Gegeninduktivität M
M1 = 0.2 * c1 * log(b1/a1)  % uH

% Eigeninduktivität L
% 2 x lange Seite
r1 = r;
S1 = B - r;
S2 = L - d;
% 2 x kurze Seite
r1 = r;
S1 = L - r;
S2 = B - d;

L1 = 2*IN_3(r, L-r, B-d) + 2*IN_3(r, B-r, L-d)

% induzierter Strom
I2 = I1 * M1/L1
di_dt_2 = I2/tr;
% Lösung: I2 = 2.0122 A


%%
% b)
% nur Leiter, ohne erste Schlaufe
clc;
r1 = 4e-3 + B + 2e-3 + r;
S1 = 4e-3 + B + 2e-3 + B - r;
S2 = L - d;

% M_Leiter = IN_3(r1, S1, S2)
c1 = L -d;
b1 = B + 4e-3 - r;
a1 = 4e-3 + r;
M_Leiter = 0.2 * c1 * log(b1/a1)  % uH
M_Leiter = 10.7e-3

% erste Schlaufe
% 2 x IN4 + IN3 - IN3
% IN4
r1 = r;
S3 = L - r;
S4 = B - d + 2e-3;
in4 = ( IN_4(r1, S3, S4) - IN_4(r1, S3, 2e-3) )

% nähere Parallele
r1 = 2e-3 + r;
S1 = 2e-3 + B - r;
S2 = L - d;
in3_nah = IN_3(r1, S1, S2)
% M_nah = 39.0338 nH

% entferntere Parallele
r1 = B + 2e-3 + r;
S1 = B + 2e-3 + B - r;
S2 = L - d;
in3_fern = IN_3(r1, S1, S2)
% M_fern = 8.9188 nH

% Vorzeichenfehler Vorbehalten !!!
M_Schlaufe = - (2* in4 + in3_fern - in3_nah)

%% Induktionsgesetz
% U = M * di/dt
% nur Leiter
Ul = M_Leiter *10^-6 * di_dt
% 1. Schlaufe
Us = (M_Schlaufe) *10^-6 * di_dt_2
% total
U = Ul + Us

%%
clc;
% I1 über M
U1m = di_dt * M_Leiter * 10^-6
% I2 über M2fern
U2f = -di_dt_2 * in3_fern * 10^-6
% I2 über M2nah
U2n = di_dt_2 * in3_nah *10^-6
% I2 über M2ecke
U2e = -2 * di_dt_2 * in4 * 10^-6

Utot = U1m + U2f + U2n + U2e




