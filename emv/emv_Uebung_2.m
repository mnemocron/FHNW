%******************************************************************************
% \details     : EMV 
% \autor       : Simon Burkhardt
% \file        : emv_Uebung_2.m
% \date        : 07.03.2020
% \version     : 1.1
%******************************************************************************
clear all; close all; clc; format shorteng;
d = 1e-3;   % m
r = d/2;
% Strom
I1 = 8;      %  8 A
tr = 40e-9;  % 40 ns
di_dt = I1/tr;

% a)
% unendlicher Leiter --> Baustein 1
a1 = 5e-3 + r;
b1 = 5e-3 + 120e-3 -r;
c1 = 100e-3 - d;

% Gegeninduktivität M
M1 = 0.2 * c1 * log(b1/a1);  % uH
disp(strcat("M = IN1(a = ",num2str(a1), ", b = ", num2str(b1), ", c = ", num2str(c1), ") = ", num2str(M1), " uH"))

% Eigeninduktivität L
% 2 x lange Seite
r1 = r;
S1 = 100e-3 - r;
S2 = 120e-3 - d;
Llang = IN_3(r1, S1, S2);
disp(strcat("L_lang = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(Llang), " uH"))
% 2 x kurze Seite
r1 = r;
S1 = 120e-3 - r;
S2 = 100e-3 - d;
Lkurz = IN_3(r1, S1, S2);
disp(strcat("L_kurz = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(Lkurz), " uH"))
L1 = 2*Lkurz + 2*Llang;
disp(strcat("L1 = 2x L_lang + 2x L_kurz = ", num2str(L1), " uH"))

% induzierter Strom
I2 = I1 * M1/L1
di_dt_2 = I2/tr;

%% b) 
clc;

% nur Leiter, ohne erste Schlaufe
a1 = 5e-3 + r;
b1 = 5e-3 + 120e-3 - r;
c1 = 50e-3 - d;
M_Leiter = 0.2 * c1 * log(b1/a1);  % uH
disp(strcat("M_Leiter = IN1(a = ",num2str(a1), ", b = ", num2str(b1), ", c = ", num2str(c1), ") = ", num2str(M_Leiter), " uH"))
U_Leiter = M_Leiter * di_dt * 1e-6;
disp(strcat("U_Leiter = ", num2str(U_Leiter)))

% nähere Parallele
r1 = 1e-3 + r;
S1 = 1e-3 + 50e-3 - r;
S2 = 120e-3 - d;
in3_nah = IN_3(r1, S1, S2);
disp(strcat("L_nah  = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(in3_nah), " uH"))
U_nah = in3_nah * 1e-6 * di_dt_2;  % positiv
disp(strcat("U_nah  = ", num2str(U_nah)))

% entferntere Parallele
r1 = 100e-3 + 1e-3 + r;
S1 = 100e-3 + 1e-3 + 50e-3 - r;
S2 = 120e-3 - d;
in3_fern = IN_3(r1, S1, S2);
disp(strcat("L_fern = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(in3_fern), " uH"))
U_fern = -in3_fern * 1e-6 * di_dt_2;  % negativ
disp(strcat("U_fern = ", num2str(U_fern)))

% 2x senkrechte --> IN4
r1 = r;
S3 = 120e-3 - r;
S4 = 50e-3 - r;
in4_p = IN_4(r1, S3, S4);
disp(strcat("IN4p = IN4(r = ", num2str(r1), ", S3 = ", num2str(S3), ", S4 = ", num2str(S4), ") = ", num2str(in4_p), " uH"))

% abzüglich Spalt
r1 = r;
S3 = 120e-3 - r;
S4 = 1e-3 - r;
in4_m = IN_4(r1, S3, S4);
disp(strcat("IN4m = IN4(r = ", num2str(r1), ", S3 = ", num2str(S3), ", S4 = ", num2str(S4), ") = ", num2str(in4_m), " uH"))
IN4 = in4_p - in4_m;
L_par = 2*IN4;
disp(strcat("L_par = 2x IN4 = 2x ", num2str(IN4), " uH = ", num2str(2*IN4), " uH"));
U_par = -L_par * 1e-6 * di_dt_2;  % negativ
disp(strcat("U_par = ", num2str(U_par)))

Utot = U_Leiter + U_nah + U_fern + U_par;
disp(strcat("U = ", num2str(U_Leiter), " + ", num2str(U_nah), " + ", num2str(U_fern), " + ", num2str(U_par), " = ", num2str(Utot), " V"))



