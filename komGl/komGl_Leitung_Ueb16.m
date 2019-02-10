

clear all; clc; format shorteng;

Ls = 2e-4;
Rs=0;
Gs=0;
Cs=55.555e-9;
f=300e3;
w=2*pi*f;

Zw = sqrt( (Rs+j*w*Ls)/(Gs+j*w*Cs) )

Z1K = -j*170;

% Lösung a)
Z1L = Zw^2 / Z1K

%%
gam = sqrt( (Rs+j*w*Ls)*(Gs+j*w*Cs)  )
Bet = gam/j

l = atanh(Z1K/Zw)/gam

clear l
syms l
gl = Z1L == Zw/tanh(gam*l);
assume(l, 'positive')
lsg = solve(gl, l);
vpa(lsg)
% = 0.304



