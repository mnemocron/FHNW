

%%
% Aufgabe 1
clear all; clc;
format shorteng

Z12_ = 12+j*5;
Z23_ = 3-j*6;
Z31_ = 1-j*7;

Zz_ = 1.8;

Zst_ = dreieck2stern(Z12_, Z23_, Z31_, false)

Z1ms_ = Zst_.Ra
Z2ms_ = Zst_.Rb
Z3ms_ = Zst_.Rc

Z1m_ = Z1ms_ + Zz_
Z2m_ = Z2ms_ + Zz_
Z3m_ = Z3ms_ + Zz_

%%
% weiter rechnen
% zurück nach Dreieckschaltung

U1m_ = 100*exp(j*(-2*pi/3*0));
U2m_ = 100*exp(j*(-2*pi/3*1));
U3m_ = 100*exp(j*(-2*pi/3*2));


Z1_ = Z1m_;
Z2_ = Z2m_;
Z3_ = Z3m_;

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
U1_ = 100*exp(j*(-2*pi/3*0));
U2_ = 100*exp(j*(-2*pi/3*1));
U3_ = 100*exp(j*(-2*pi/3*2));

Zdr_ = stern2dreieck(Z1m_, Z2m_, Z3m_, false)

U12_ = U2_ - U1_;
U23_ = U3_ - U2_;
U31_ = U1_ - U3_;

Z12_ = Zdr_.Rab;
Z23_ = Zdr_.Rac;
Z31_ = Zdr_.Rbc;

I12_ = U12_/Z12_;
I23_ = U23_/Z23_;
I31_ = U31_/Z31_;

I12=strcat(num2str(abs(I12_)), "A /_ ", num2str(rad2deg(angle(I12_))), "°")
I23=strcat(num2str(abs(I23_)), "A /_ ", num2str(rad2deg(angle(I23_))), "°")
I31=strcat(num2str(abs(I31_)), "A /_ ", num2str(rad2deg(angle(I31_))), "°")

% Knotensatz !!!!!
I1_ = I12_ - I31_
I2_ = I23_ - I12_
I3_ = I31_ - I23_

I1=strcat(num2str(abs(I1_)), "A /_ ", num2str(rad2deg(angle(I1_))), "°")
I2=strcat(num2str(abs(I2_)), "A /_ ", num2str(rad2deg(angle(I2_))), "°")
I3=strcat(num2str(abs(I3_)), "A /_ ", num2str(rad2deg(angle(I3_))), "°")

%%
% Aufgabe 2
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
% Aufgabe 3
% f und X gegeben

clear all; clc;

f1 = 1e6;
f2 = 10e6;

X1 = -132;
X2 = -10.2;

w1 = 2*pi*f1;
w2 = 2*pi*f2;

syms L C

gl1 = w1*L - 1/(w1*C) == X1;
gl2 = w2*L - 1/(w2*C) == X2;
assume(L, 'positive');
assume(C, 'positive');
lsg = solve(gl1, gl2);
disp(['C = ', num2str(double(lsg.C)), ' F']);
disp(['L = ', num2str(double(lsg.L)), ' H']);

Cc = lsg.C;
Ll = lsg.L;

Z1_ = vpa(imag(j*w1*Ll + 1/(j*w1*Cc)))
Z2_ = vpa(imag(j*w2*Ll + 1/(j*w2*Cc)))

%% 
% Aufgabe 4

clear all; clc;

R1 = 100;
R2 = 10;
w0 = 1e6;

Q = sqrt(R1/R2)

C = Q/R1 * 1/w0
L = R1/Q * 1/w0

C = sqrt(R1)/(sqrt(R2)*R1*w0)
L = R1*sqrt(R2)/(sqrt(R1)*w0)

s = tf('s');

Z = s*L + 1/( 1/R1 + s*C );
nyquist(Z)

%%
clear all; clc;

Rc = 100;
C = 3.1623e-8;
L = 3.1623e-5;

w0 = 1/sqrt(L*C)
Qc = Rc*sqrt(C/L);
wr = w0*sqrt(1/(1-1/(Qc^2)))


%%
% Aufgabe 5
% Netzwerk gegeben

clear all; clc;
format shorteng

C = 100e-12;
L = 560e-9;
R1 = 450;
R2 = 25;

w0 = 1/sqrt(L*C)
Ql = 1/R2 * sqrt(L/C);
wr = w0*sqrt(1 - 1/(Ql^2))
wr = 1/sqrt(L*C) * sqrt(1 - (R2^2 * C)/L )
fres = wr /(2*pi)

Y_ = 1/R1 + j*wr*C + 1/(R2 + j*wr*L)
ImY = wr*C - (wr*L)/(R2^2 + (wr*L)^2)


