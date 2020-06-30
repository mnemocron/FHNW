%******************************************************************************
% \details     : EMV 
% \autor       : Simon Burkhardt
% \file        : emv_Uebung_3.m
% \date        : 14.03.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;
d = 1e-3;   % m
r = d/2;
% Strom
I1 = 15;     % 15 A
tr = 30e-9;  % 30 ns
di_dt = I1/tr;

% a)
% unendlicher Leiter --> Baustein 1
a1 = 2.5e-3 + r;
b1 = 2.5e-3 + 50e-3 -r;
c1 = 80e-3 - d;
% Gegeninduktivität M
M1 = 0.2 * c1 * log(b1/a1);  % uH
disp(strcat("M = IN1(a = ",num2str(a1), ", b = ", num2str(b1), ", c = ", num2str(c1), ") = ", num2str(M1), " uH"))

% Eigeninduktivität L
% 2 x lange Seite
r1 = r;
S1 = 50e-3 - r;
S2 = 80e-3 - d;
Llang = IN_3(r1, S1, S2);
disp(strcat("L_lang = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(Llang), " uH"))
% 2 x kurze Seite
r1 = r;
S1 = 80e-3 - r;
S2 = 50e-3 - d;
Lkurz = IN_3(r1, S1, S2);
disp(strcat("L_kurz = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(Lkurz), " uH"))
L1 = 2*Lkurz + 2*Llang;
disp(strcat("L1 = 2x L_lang + 2x L_kurz = ", num2str(L1), " uH"))

% induzierter Strom
I2 = I1 * M1/L1
di_dt_2 = I2/tr;

%%
clc;

% nur Leiter, ohne erste Schlaufe
a1 = 2.5e-3 + r;
b1 = 2.5e-3 + 50e-3 - r;
c1 = 8e-3 - d;
M_Leiter = 0.2 * c1 * log(b1/a1);  % uH
disp(strcat("M_Leiter = IN1(a = ",num2str(a1), ", b = ", num2str(b1), ", c = ", num2str(c1), ") = ", num2str(M_Leiter), " uH"))
U_Leiter = M_Leiter * di_dt * 1e-6;
disp(strcat("U_Leiter = ", num2str(U_Leiter)))

% nähere Parallele
r1 = 2.5e-3 + r;
S1 = 2.5e-3 + 8e-3 - r;
S2 = 50e-3 - d;
in3_nah = IN_3(r1, S1, S2);
disp(strcat("L_nah  = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(in3_nah), " uH"))
U_nah = in3_nah * 1e-6 * di_dt_2;  % positiv
disp(strcat("U_nah  = ", num2str(U_nah)))

% entferntere Parallele
r1 = 80e-3 + 2.5e-3 + r;
S1 = 80e-3 + 2.5e-3 + 8e-3 - r;
S2 = 50e-3 - d;
in3_fern = IN_3(r1, S1, S2);
disp(strcat("L_fern = IN3(r = ",num2str(r1), ", S1 = ", num2str(S1), ", S2 = ", num2str(S2), ") = ", num2str(in3_fern), " uH"))
U_fern = -in3_fern * 1e-6 * di_dt_2;  % negativ
disp(strcat("U_fern = ", num2str(U_fern)))

% 2x senkrechte --> IN4
r1 = r;
S3 = 50e-3 - r;
S4 = 8e-3 + 2.5e-3 - r;
in4_p = IN_4(r1, S3, S4);
disp(strcat("IN4p = IN4(r = ", num2str(r1), ", S3 = ", num2str(S3), ", S4 = ", num2str(S4), ") = ", num2str(in4_p), " uH"))

% abzüglich Spalt
r1 = r;
S3 = 50e-3 - r;
S4 = 2.5e-3 - r;
in4_m = IN_4(r1, S3, S4);
disp(strcat("IN4m = IN4(r = ", num2str(r1), ", S3 = ", num2str(S3), ", S4 = ", num2str(S4), ") = ", num2str(in4_m), " uH"))
IN4 = in4_p - in4_m;
L_par = 2*IN4;
disp(strcat("L_par = 2x IN4 = 2x ", num2str(IN4), " uH = ", num2str(2*IN4), " uH"));
U_par = -L_par * 1e-6 * di_dt_2;  % negativ
disp(strcat("U_par = ", num2str(U_par)))

Utot = U_Leiter + U_nah + U_fern + U_par;
disp(strcat("U = ", num2str(U_Leiter), " + ", num2str(U_nah), " + ", num2str(U_fern), " + ", num2str(U_par), " = ", num2str(Utot), " V"))

%% c)
clc;
% Rcu = rho * l / A;
rho = 0.0178;  % Ohm * mm2 / m
Ad = r^2 * pi; % mm2
l2 = 2* 80e-3 + 2*50e-3;
Rl = rho * l2 /Ad        % Ohm
Llang = 64.2859e-009     % Henry
f0 = Rl / (2*pi*Llang)


%% d)
clc;
% Ferritperle
lf = 1.5e-3;
da = 4e-3;
di = 2e-3;
% Ferritkern = IN1
mu0 = 4*pi*1e-7;
mur = 230;

Lf = mu0 * mur /2/pi * lf * log(da/di);  % H
disp(strcat("L_ferrit = IN1(a = ",num2str(a1), ", b = ", num2str(b1), ", c = ", num2str(c1), ") = ", num2str(Lf), " H"))

%%
U_Leiter = 1.9968;
L_nah  = IN_3(0.003, 0.01, 0.049);
L_fern = IN_3(0.083, 0.09, 0.049);
IN4p = IN_4(0.0005, 0.0495, 0.01);  % = 0.0019575 uH
IN4m = IN_4(0.0005, 0.0495, 0.002); %= 0.00066028 uH
L_par = 2* IN4p - 2* IN4m;

% Anzahl Ferrite:
n = 2;

I2s = M1*1e-6 /(n*Lf)*I2;
di_dt_2s = I2s/tr;

U_nah = in3_nah * 1e-6 * di_dt_2s;  % positiv
U_fern = -in3_fern * 1e-6 * di_dt_2s;  % negativ
U_par = -L_par * 1e-6 * di_dt_2s;  % negativ
Utot = U_Leiter + U_nah + U_fern + U_par;
disp(strcat("U = ", num2str(U_Leiter), " + ", num2str(U_nah), " + ", num2str(U_fern), " + ", num2str(U_par), " = ", num2str(Utot), " V"))

% n=1 --- U = 1.9968 + 1.0776 + -0.0215 + -0.2665 = 2.7864 V
% n=2 --- U = 1.9968 + 0.5388 + -0.0107 + -0.1332 = 2.3916 V
% n=3 --- U = 1.9968 + 0.3592 + -0.0071 + -0.0888 = 2.26 V

% n=2 reicht aus um Utot < 2.5V zu bekommen























