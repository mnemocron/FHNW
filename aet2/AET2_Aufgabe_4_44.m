%******************************************************************************
% \details     : AET2 Aufgabe 4-44
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_44.m
% \date        : 21.03.2018
% \version     : 1.0
%******************************************************************************

clear; clc;
%close all

Ca=10e-9;
La=10e-3;
Ra=500;

Cb=Ca;
Lb=La;
Rb=Ra;

Cc=10e-9;
R1c=200;
R2c=100;
Lc=10e-3;

Cd=Ca;
Ld=La;
Rd=5e3;

Ce=Ca;
Le=La;
Re=Rd;
Cf=Ca;
Lf=10e-3;
R1f=20e3;
R2f=10e3;

w=logspace(2, 8, 1e3);

%%
% a) (stimmt)
wresa=sqrt(1/(La*Ca)-(Ra^2)/(La^2))
fresa=wresa/2/pi;
wa=logspace(log10(wresa)-3, log10(wresa)+3, 1e3);
%Ya=1/Ra+1./(j*w*La);
Ya=j*w*Ca + 1./(Ra + j*w*La);
Za=1./Ya;

%%
% b) (stimmt)
Yb=1./(j*w*Lb) + 1./(Rb+1./(j*w*Cb));
Zb=1./Yb;

% c) (stimmt)
Z1c=R1c+1./(j*w*Cc);
Z2c=R2c+j*w*Lc;
Yc=1./Z1c + 1./Z2c;
Zc=1./Yc;
%Z=par(Z1, Z2);

% d)
Y1d=1/Rd + 1./(j*w*Ld);
Z1d=1./Y1d;
Zd=Z1d + 1./(j*w*Cd);
Yd=1./Zd;

% e)
Y1e=1/Re+j*w*Ce;
Z1e=1./Y1e;
Ze=Z1e+j*w*Le;
Ye=1./Ze;

% f) (stimmt ?)
Y1f=1/R1f+1./(j*w*Lf);
Y2f=1/R2f+j*w*Cf;
Z1f=1./Y1f;
Z2f=1./Y2f;
Zf=Z1f+Z2f;
Yf=1./Zf;

% Elektrotechnische Überlegung abgeschlossen
% Ab hier folg Bedienung von Matlab

%%

figure(1)
subplot(3,2,1)
plot(Za)
hold on; grid on; axis square;
axis([min(real(Za)), max(real(Za)), min(imag(Za)), max(imag(Za))])
%axis([0 2500 -1500 500])
title("a) Z")

subplot(3,2,2)
plot(Zd)
hold on; grid on; axis square;
axis([min(real(Zd)), max(real(Zd)), min(imag(Zd)), max(imag(Zd))])
%axis([0, 1, min(imag(Zd)), max(imag(Zd))])
title("d) Z")

subplot(3,2,3)
plot(Zb)
hold on; grid on; axis square;
axis([min(real(Zb)), max(real(Zb)), min(imag(Zb)), max(imag(Zb))])
title("b) Z")

subplot(3,2,4)
plot(Ze)
hold on; grid on; axis square;
axis([min(real(Ze)), max(real(Ze)), min(imag(Ze)), max(imag(Ze))])
title("e) Z")

subplot(3,2,5)
plot(Zc)
hold on; grid on; axis square;
axis([min(real(Zc)), max(real(Zc)), min(imag(Zc)), max(imag(Zc))])
%axis([0 4000 -2000 2000])
title("c) Z")

subplot(3,2,6)
plot(Zf)
hold on; grid on; axis square;
axis([min(real(Zf)), max(real(Zf)), min(imag(Zf)), max(imag(Zf))])
title("f) Z")

%%
figure(2)
subplot(3,2,1)
plot(Ya)
hold on; grid on; axis square;
axis([min(real(Ya)), max(real(Ya)), min(imag(Ya)), max(imag(Ya))])
title("a) Y")

subplot(3,2,2)
plot(Yd)
hold on; grid on; axis square;
axis([min(real(Yd)), max(real(Yd)), min(imag(Yd)), max(imag(Yd))])
title("d) Y")

subplot(3,2,3)
plot(Yb)
hold on; grid on; axis square;
axis([min(real(Yb)), max(real(Yb)), min(imag(Yb)), max(imag(Yb))])
title("b) Y")

subplot(3,2,4)
plot(Ye)
hold on; grid on; axis square;
axis([min(real(Ye)), max(real(Ye)), min(imag(Ye)), max(imag(Ye))])
title("e) Y")

subplot(3,2,5)
plot(Yc)
hold on; grid on; axis square;
axis([min(real(Yc)), max(real(Yc)), min(imag(Yc)), max(imag(Yc))])
title("c) Y")

subplot(3,2,6)
plot(Yf)
hold on; grid on; axis square;
axis([min(real(Yf)), max(real(Yf)), min(imag(Yf)), max(imag(Yf))])
title("f) Y")


