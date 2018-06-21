%******************************************************************************
% \details     : AET2 Aufgabe 4-68
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_68.m
% \date        : 08.05.2018
% \version     : 1.0
%******************************************************************************
clear all; clc

L=100e-3;
C=10e-6;
Rs=12.5;
Ip=0.1;
w=1e3;

T=2*pi/w;
t=linspace(0, 2*T, 1e3);

I_ = Ip/sqrt(2) * cis(0, 'deg');
Ur_ = I_ * Rs;
Ul_ = I_ * j*w*L;
Uc_ = I_ / (j*w*C);

i = Ip*cos(w*t);
ur = abs(Ur_)*sqrt(2)*cos(w*t + angle(Ur_));
ul = abs(Ul_)*sqrt(2)*cos(w*t + angle(Ul_));
uc = abs(Uc_)*sqrt(2)*cos(w*t + angle(Uc_));

subplot(2, 2, 1)
plot(t, i, t, ur, t, ul, t, uc)

wc = 1/2*C*uc.^2;
wl = 1/2*L*i.^2;

W = wl+wc;
p = ur.^2 / Rs;

subplot(2, 2, 2)
plot(t, wc, t, wl, t, W)

subplot(2, 2, 3)
plot(t, p)
% P = mean(p)
P = (max(p) + min(p))/2;
line([0 2*T],[P, P])
wmax = max(W)

Q = 2*pi*wmax/(T*P)

Q = 1/(Rs*w*C)
Q = w*L/Rs

Q=max(ul) / max(ur)
Q=max(uc) / max(ur)


