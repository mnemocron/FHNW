% 4-28
clear; clc;
format shorteng;

I=10/sqrt(2)*exp(j*0)
pmax=3700;
pmin=-1700;
T=500e-6;
fp=1/T;
f=fp/2      % 1kHz
w=2*pi*f;

P=1/2*(pmax+pmin)
Q=sqrt(-pmax*pmin)

S=P+j*Q;

% Ansatz: 
phiU=acos((pmax+pmin)/(pmax-pmin))
% gibt immer einen positiven Winkel weil COSINUS eine GERADE Funktion
% ist. Andere überlegungen sind notwendig

% ohmsch-induktiv
% S = Z * I^2
Z=S/abs(I)^2 

% Serieschaltung L + R
Rs=P/(abs(I)^2)
% Z = R+j*w*L
Ls=(Z-Rs)/(j*w)


% Parallelschaltung L || R
Y=1/Z
% Y = 1/R + 1/(j*w*L)
Rp=1/real(Y)
Lp=real(1/(j*w*(Y-(1/Rp))))


