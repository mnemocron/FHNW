clear
clc

% basteln
clear; clc;
R=10;
C=10e-6;
L=10e-3;
f=1e3;
w=2*pi*f;
t=linspace(0, 2*(1/f), 1e3);
Zr=R;
Zc=1/(j*w*C);
Zl=j*w*L;
Z=Zr+Zl;
U=10;
u=U*sqrt(2)*exp(j);
I=u/Z;
u=U*cos(w*t);
phi=angle(I);
i=cos(w*t+phi);
hold on;
grid on;
plot(t, u);
plot(t, i);
p=u.*i;
plot(t, p);


% 4-7      R    +   C
% o------[===]-----||-----o
clear; clc; close all;
pmax=79.8;
pmin=-19.8;
I=0.5;   % exp(j*w*t + phi)   % t=0 / phi=0 % EFFEKTIVWERT !!!
f=10e3;
w=2*pi*f;

% Leistung am Widerstand:
Pmittel = abs((pmax+pmin)/2);     % Wirkleistung
Pamplitude = abs((pmax-pmin)/2);  % Blindleistung
% Pm + Pa*cos(2*w*t)    % doppelte frequenz
t=linspace(0, 2*(1/f), 1e3);
p=Pmittel + Pamplitude*cos(2*w*t);
plot(t, p);
axis([0 2e-4 -25 100]);
grid on;
%max(p) % =  79.8 stimmt
%min(p) % = -19.8 stimmt

Ur=Pmittel/I; % Wirkleistung
R=Ur/I
% 120 Ohm
% Kontrolle
ii=I*sqrt(2)*cos(w*t);
pr=ii.^2.*R;
mean(pr)
% ans = 30.0300e+000    stimmt

% Xc = 1/(2*pi*f*C*j)
phi=acos((pmax+pmin)/(pmax-pmin))
P=Pamplitude*exp(phi*j);    % Spitzenwert
U=P/I;  % Effektivwert
Xc=R*tan(phi);
C=1/(w*Xc)
% 100.0982e-009 F stimmt

% Kontrolle
Xc = 1/(j*w*C);
Z = R+Xc;
i=I*sqrt(2)*cos(w*t);
U=I*Z;
u=abs(U)*sqrt(2)*cos(w*t+angle(U));
p=u.*i;
hold on;
plot(t, p);

% 4-8   
clear; clc;
L=25e-3;
I=12/sqrt(2);
f=50;
w=2*pi*f;
t=linspace(0, 2*(1/f), 1e3);
Z=j*w*L;
U=I*Z;
i=I*sqrt(2)*cos(w*t);
u=abs(U)*sqrt(2)*cos(w*t+angle(U));
p=u.*i;
we=1/2*L*i.^2;
subplot(411);
plot(t, i, "red");
grid on;
legend("i(t) [A]");
subplot(412);
plot(t, u, "blue");
grid on;
legend("u(t) [V]");
subplot(413);
plot(t, p, "green");
grid on;
legend("p(t) [W]");
subplot(414);
plot(t, we, "black");
grid on;
legend("w(t) [Ws]");
we_max=max(we)


% 4-9



% 4-14
clear
R = 47;
w = 1e3;
L = 25e-3;

Zr = R
Zl = j*w*L
% Impedanz in Ohm
Z = Zr+Zl   % Lösung 1 - arithmetisch
abs(Z)      % Lösung 2 - Winkelform
angle(Z)
rad2deg(angle(Z)) % Lösung 3 - Winkelform in Grad

Y=1/Z       % Admittanz in Simemens
abs(Y)
angle(Y)    % muss invers sein zum Winkel der Impedanz
rad2deg(angle(Y))


% 4-15
clear
R = 22;
C = 25e-9;
w = 1e6;

Yr = 1/R;
Yc = j*w*C;

Y = Yr+Yc
abs(Y)
rad2deg(angle(Y))

Z = 1/Y
abs(Z)
rad2deg(angle(Z))




% 4-21
clear
f = 625;
w=2*pi*f;
% a)
U = 39.6/sqrt(2)*exp(j*((-pi/2)-(pi/5)))
% 18 /_-7pi/10
% b)
R = 9600;
C = 90.9e-9;
Z = R + 1/(j*w*C) % 10k /_ -16.3° Ohm
% abs(Z)  % rad2deg(Z)
Y = 1/Z           % 100u /_ 16.3° Siemens
% abs(Y)  % rad2deg(Y)
% c)
I = U/Z   % 2.8m /_ -109.7° A
Ip = abs(I)*sqrt(2)  % 0.004
% i(t) = 4mA * cos(w*t -109.7°)
% d)
% e)
% w*t-1.51==pi/2-k*pi
% T/2 = 0.8ms
% what? t1 = 0.088ms
t=linspace(0, 4e-3, 1e3);
i=sqrt(2)*2.8e-3*cos(w*t-1.915);
plot(t,i)


% 4-22
clear
Up = 10;
w1 = 2*pi*1e6;
w2 = 2*pi*2.3e6;
L = 10e-6;
C = 500e-12;
R = 200;

Zr = R;
Zl1 = j*w1*L;
Zc1 = 1/(j*w1*C);
Zw1 = 1/( 1/Zr + 1/Zl1 + 1/Zc1 )
Zl2 = j*w2*L;
Zc2 = 1/(j*w2*C);
Zw2 = 1/( 1/Zr + 1/Zl2 + 1/Zc2 )

Yr = 1/R;
Yl1 = 1/(j*w1*L);
Yc1 = j*w1*C;
Yl2 = 1/(j*w2*L);
Yc2 = j*w2*C;
Yw1 = Yr + Yl1 + Yc1
Zw1 = 1/Yw1
Yw2 = Yr + Yl2 + Yc2
Zw2 = 1/Yw2

U = Up*sqrt(2)*exp(j);
Ir = U/Zr;
Il1 = U/Zl1;
Ic1 = U/Zl2;
hold on
compass(Ir)
compass(Il1)
compass(Ic1)


% 4-23
clear
w = 1000;
C = 500e-9;
L = 1;
R1 = 1e+3;
R2 = 2e+3;
R3 = 1e+3;
Z1 = (1+2*j)*10^3; Y1 = 1/Z1;
Z2 = (2-j)*10^3;   Y2 = 1/Z2;

Zc = 1/(j*w*C); Yc = 1/Zc;
Zl = j*w*L;     Y1 = 1/Z1;
ZR1 = R1;       YR1 = 1/ZR1;
ZR2 = R2;       YR2 = 1/ZR2; 
ZR3 = R3;       YR3 = 1/ZR3;

Ztot = 1/(Y1 + 1/( 1/(1/(Z2 + ZR3) + Y2) + Zl )) + ZR1 + Zc
% 2250.7 /_ -40.95° Ohm
















