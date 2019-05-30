%**************************************************************************
% \details     : Fehlerrechnungen für E4.3
% \autor       : Simon Burkhardt
% \file        : glal4_phys_e4_3_Fehlerrechung.m
% \date        : 19.04.2019
% \version     : 1.0
%**************************************************************************
clear all; clc; format shorteng;

% Fehler
s_I = 0.08 * 0.6; % Messgenauigkeit
s_R = 2.15 * 10^(-3); % geschaetzt
s_Fz = 0.01; % geschaetzt
s_len = 0.5e-3; % ALU-Spulenkoerper
s_lm = 5e-4; % geschaetzt
s_dm = 5e-4; % geschaetzt

mag1.zm = -0.0650415; % Mittelwert
mag1.Fm = -0.00019;   % Mittelwert
mag1.dm = 6e-3;
mag1.lm = 13e-3;
mag1.Br = 1.38926e-1; % aus Fit
mag1.s_Br = 0.0017672; % aus Fit
mag1.z0 = -5.7073397e-2; % aus Fit
mag1.s_z0 = 2.20218e-4; % aus Fit

mag2.zm = -0.068987368;
mag2.Fm = -7.89474E-05;
mag2.dm = 15e-3;
mag2.lm = 8e-3;
mag2.Br = 1.37082e-1;
mag2.s_Br = 0.002448622;
mag2.z0 = -5.651e-2;
mag2.s_z0 = 1.2028e-3;

mag3.zm = -0.080032941;
mag3.Fm = 5.88235E-06;
mag3.dm = 6e-3;
mag3.lm = 3*13e-3;
mag3.Br = 1.417485e-1;
mag3.s_Br = 0.000656939;
mag3.z0 = -5.7254986e-2;
mag3.s_z0 = 1.048331e-4;

% alles Symbolisch für partielle Ableitung
syms dm z0 lm Fz z I len R Br;
mu0 = pi*4e-7;
N = 474;

Fz = Br*pi*(dm/2)^2 * ...
    ( (mu0 * N * I)/len  * ...
    1/2*( ( (len/2 + (z-z0))/sqrt( (len/2+(z-z0))^2 + R^2) ) ...
    + ( (len/2 - (z-z0))/sqrt( (len/2-(z-z0))^2 + R^2) ) ) ...
  - (mu0 * N * I)/len  * ...
    1/2*( ( (len/2 + (z+lm-z0))/sqrt( (len/2+(z+lm-z0))^2 + R^2) ) ...
    + ( (len/2 - (z+lm-z0))/sqrt( (len/2-(z+lm-z0))^2 + R^2) ) ) );

dF_dI = diff(Fz, I, 1);
dF_dlen = diff(Fz, len, 1);
dF_dR = diff(Fz, R, 1);
dF_dlm = diff(Fz, lm, 1);
dF_ddm = diff(Fz, dm, 1);
% Statistischer Fehler
dF_dz0 = diff(Fz, z0, 1);
dF_dBr = diff(Fz, Br, 1);

% Variablen substituieren
clear I len R lm dm Br;
I = 0.6;
len = 0.068;
R = 0.014;

z0 = mag1.z0;
lm = mag1.lm;
dm = mag1.dm;
Br = mag1.Br;
mag1.df_I   = eval(subs(dF_dI,   z, mag1.zm)) * s_I;
mag1.df_len = eval(subs(dF_dlen, z, mag1.zm)) * s_len;
mag1.df_R   = eval(subs(dF_dR,   z, mag1.zm)) * s_R;
mag1.df_lm  = eval(subs(dF_dlm,  z, mag1.zm)) * s_lm;
mag1.df_dm  = eval(subs(dF_ddm,  z, mag1.zm)) * s_dm;
mag1.df_z0  = eval(subs(dF_dz0,  z, mag1.zm)) * mag1.s_z0;
mag1.df_Br  = eval(subs(dF_dBr,  z, mag1.zm)) * mag1.s_Br;

mag1.s_Fz = sqrt( mag1.df_I^2 + mag1.df_len^2 + mag1.df_R^2 ...
    + mag1.df_lm^2 + mag1.df_z0^2 + mag1.df_Br^2)

z0 = mag2.z0;
lm = mag2.lm;
dm = mag2.dm;
Br = mag2.Br;
mag2.df_I   = eval(subs(dF_dI,   z, mag2.zm)) * s_I;
mag2.df_len = eval(subs(dF_dlen, z, mag2.zm)) * s_len;
mag2.df_R   = eval(subs(dF_dR,   z, mag2.zm)) * s_R;
mag2.df_lm  = eval(subs(dF_dlm,  z, mag2.zm)) * s_lm;
mag2.df_dm  = eval(subs(dF_ddm,  z, mag2.zm)) * s_dm;
mag2.df_z0  = eval(subs(dF_dz0,  z, mag2.zm)) * mag2.s_z0;
mag2.df_Br  = eval(subs(dF_dBr,  z, mag2.zm)) * mag2.s_Br;

mag2.s_Fz = sqrt( mag2.df_I^2 + mag2.df_len^2 + mag2.df_R^2 ...
    + mag2.df_lm^2 + mag2.df_z0^2 + mag2.df_Br^2)

z0 = mag3.z0;
lm = mag3.lm;
dm = mag3.dm;
Br = mag3.Br;
mag3.df_I   = eval(subs(dF_dI,   z, mag3.zm)) * s_I;
mag3.df_len = eval(subs(dF_dlen, z, mag3.zm)) * s_len;
mag3.df_R   = eval(subs(dF_dR,   z, mag3.zm)) * s_R;
mag3.df_lm  = eval(subs(dF_dlm,  z, mag3.zm)) * s_lm;
mag3.df_dm  = eval(subs(dF_ddm,  z, mag3.zm)) * s_dm;
mag3.df_z0  = eval(subs(dF_dz0,  z, mag3.zm)) * mag3.s_z0;
mag3.df_Br  = eval(subs(dF_dBr,  z, mag3.zm)) * mag3.s_Br;

mag3.s_Fz = sqrt( mag3.df_I^2 + mag3.df_len^2 + mag3.df_R^2 ...
    + mag3.df_lm^2 + mag3.df_z0^2 + mag3.df_Br^2)









