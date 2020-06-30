%******************************************************************************
% \details     : kryg 
% \autor       : Simon Burkhardt
% \file        : kryg_Uebung_4.m
% \date        : 14.03.2020
% \version     : 1.0
%******************************************************************************
% Aufgabe 1: f) und g)
clear all; close all; clc; format shorteng;

xtimes('53')  % 0xa6
xtimes('a6')  % 0x57

multgf256('53', '02')   % 0xa6
multgf256('53', '04')   % 0x57
multgf256('a6', '02')   % 0x57

%%
clear all; close all; clc; format short;



invgf256_hufi('ca')
invgf256('ca')
invgf256('53')
invgf256('00')

%% Azfgabe 2 - b)
clear; clc;

kt = 'ca';
b = bitget(hex2dec(kt), 8:-1:1);

AM = [1 0 0 0 1 1 1 1;
      1 1 0 0 0 1 1 1;
      1 1 1 0 0 0 1 1;
      1 1 1 1 0 0 0 1;
      1 1 1 1 1 0 0 0;
      0 1 1 1 1 1 0 0;
      0 0 1 1 1 1 1 0;
      0 0 0 1 1 1 1 1;];
C = [1 1 0 0 0 1 1 0];
  
nv = mod(AM*b', 2)';
nv = mod(nv + C, 2);
dec2hex(bi2de(nv))

% c)
kt = '00'M
b = bitget(hex2dec(kt), 8:-1:1);
nv = mod(AM*b', 2)';
nv = mod(nv + C, 2);
dec2hex(bi2de(nv))



%%
clear; clc;

A = [1 0 0;
    0 2 0;
    0 0 3];

b = [1 0 0];
A*b'






