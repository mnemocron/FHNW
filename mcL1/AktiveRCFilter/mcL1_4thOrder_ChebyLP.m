%******************************************************************************
% \details     : mcL1 - 
%                Chebycheff Low Pass Filter 4th Order
%                fg = 1kHz
%                Rp = 3 dB
%                k = 1
% \autor       : Simon Burkhardt
% \file        : 
% \date        : 2019.09.22
% \version     : 1.0
%******************************************************************************

clear all; clc;
format shorteng

fg = 1e3;
wg = 2*pi*fg;
k = -1;  % inverting amplifiers

% Chebyshev parameters from Table (3dB ripple)
a = [2.1853 0.1964]; % a1i
b = [5.5339 1.2009]; % a2i

% % Butterworth
% a = [1.8478 0.7654];
% b = [1 1];

% C2/C1
c2factor_1 = 4*b(1)/(a(1)^2)*(1-k)
c2factor_2 = 4*b(2)/(a(2)^2)*(1-k)
% selection of C
C1 = [10e-9, 390e-12];  % Musterlösung
C2 = [100e-9, 100e-9];

R2_1 = ( a(1)*C2(1) - sqrt( (a(1)*C2(1))^2 -4*C1(1)*C2(1)*b(1)*(1-k) ) ) / (4*pi*fg*C1(1)*C2(1));
R2_2 = ( a(2)*C2(2) - sqrt( (a(2)*C2(2))^2 -4*C1(2)*C2(2)*b(2)*(1-k) ) ) / (4*pi*fg*C1(2)*C2(2));
R2 = [R2_1, R2_2];

R1 = [R2_1/(-k), R2_2/(-k)];

R3_1 = b(1) / (4*pi^2*fg^2*R2(1)*C1(1)*C2(1));
R3_2 = b(2) / (4*pi^2*fg^2*R2(2)*C1(2)*C2(2));
R3 = [R3_1, R3_2];

% print results
C1
C2
R1
R2
R3


%%
% Check
clc
R1 = [12e3 33e3];
R2 = [12e3 33e3];
R3 = [10e3 22e3];

fg1 = a(1) / ( C1(1) *( R2(1) + R3(1) + R2(1)*R3(1)/R1(1) ) ) / 2/pi
fg1 = sqrt( b(1) / (C1(1) * C2(1) * R2(1) * R3(1) )) /2/pi

fg2 = a(2) / ( C1(2) *( R2(2) + R3(2) + R2(2)*R3(2)/R1(2) ) ) / 2/pi
fg2 = sqrt( b(2) / (C1(2) * C2(2) * R2(2) * R3(2) )) /2/pi

