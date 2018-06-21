
%%
% Aufgabe 1
clear all; clc;
format shorteng

Z12_ = 12+j*5;
Z23_ = 3-j*6;
Z31_ = 1-j*7;

Zz_ = 1+j*1;

Zst_ = dreieck2stern(Z12_, Z23_, Z31_, false)

Z1ms_ = Zst_.Ra;
Z2ms_ = Zst_.Rb;
Z3ms_ = Zst_.Rc;

Z1m_ = Z1ms_ + Zz_;
Z2m_ = Z2ms_ + Zz_;
Z3m_ = Z2ms_ + Zz_;

%%
% weiter rechnen
% evtl zurück nach Dreieckschaltung

Zdr_ = stern2dreieck(Z1m_, Z2m_, Z3m_, false)

U1m_ = 100*exp(j*(-2*pi/3*0));
U2m_ = 100*exp(j*(-2*pi/3*1));
U3m_ = 100*exp(j*(-2*pi/3*2));

Z1_ = (2.77 + j*0);    % 
Z2_ = (1.51+ j*1.46);  % 
Z3_ = (4.00 - j*1.83); % 
Y1_ = 1/Z1_;
Y2_ = 1/Z2_;
Y3_ = 1/Z3_;

I1_ = U1m_ / Z1_
I2_ = U2m_ / Z2_
I3_ = U3m_ / Z3_

IM_ = I1_ + I2_ + I3_;

disp(['I1 = ', num2str(abs(I1_)), 'A /_ ', num2str(rad2deg(angle(I1_))), '°'])
disp(['I2 = ', num2str(abs(I2_)), 'A /_ ', num2str(rad2deg(angle(I2_))), '°'])
disp(['I3 = ', num2str(abs(I3_)), 'A /_ ', num2str(rad2deg(angle(I3_))), '°'])
disp(['IM = ', num2str(abs(IM_)), 'A /_ ', num2str(rad2deg(angle(IM_))), '°'])

S_ = U1m_*I1_' + U2m_*I2_' + U3m_*I3_'

%%
% Aufgabe 2
% Ortskurve gegeben

R1 = 10;
R2 = 50;
w = 2*pi*1e3
syms L C

assume(C, 'positive')
assume(L, 'positive')
XL_ = 1j*w*L;
XC_ = 1/(j*w*C);
R = 10

Y_ = 1/XL_+1/(XC_+R)

% realY = R/(R^2+(1/(w*C))^2) % von Hand umgeformt

s1 = 1/50 == realY
C = solve(s1)

L = (1/w)^2/C

%%
% Aufgabe 3
% Leistungen bestimmen

clear all; clc
U12_ = 120*cis(-20, 'grad');
U23_ = 230*cis(20, 'grad');
U34_ = 180*cis(90, 'grad');
I2_ = 2*cis(30, 'grad');
I3_ = 3*cis(40, 'grad');
I4_ = 4*cis(50, 'grad');

P2 = real(-U12_*I2_')
P3 = real((-U12_-U23_)*I3_')
P4 = real((-U12_-U23_-U34_)*I4_')

P = P2+P3+P4

%%
% Aufgabe 4
% f und X gegeben

clear all; clc;

f1 = 1e6;
f2 = 10e6;

X1 = 126.2;
X2 = 2076;

w1 = 2*pi*f1;
w2 = 2*pi*f2;

syms L C

gl1 = 1/( 1/(w1*L) - (w1*C) ) == X1;
gl2 = 1/( 1/(w2*L) - (w2*C) ) == X2;
assume(L, 'positive');
assume(C, 'positive');
lsg = solve(gl1, gl2);
disp(['C = ', num2str(double(lsg.C)), ' F']);
disp(['L = ', num2str(double(lsg.L)), ' H']);

((w2/X2)-(w1/X1))/((w1^2)-(w2^2))
((1/(w1^2)) - (1/(w2^2)))/((1/(w1*X1))-(1/(w2*X2)))

%%
% Aufgabe ?
% Rs + L + (Rc || C)
clear all; clc;
format shorteng

Rc = 150;
Rs = 12;
L = 560e-9;
C = 100e-12;

w0 = 1/sqrt(L*C)
Qc = Rc*sqrt(C/L);
wr = w0*sqrt( 1 - (1/(Qc^2)) )
fres = wr/(2*pi)

Zres = Rs + j*wr*L + par(Rc, 1/(j*wr*C))

s=tf('s');
H = Rs + s*L + 1/( 1/Rc + 1/(s*C));
nyquist(H)

