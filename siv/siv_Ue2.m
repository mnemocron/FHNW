%******************************************************************************
% \details     : siv Übung 2
% \autor       : Simon Burkhardt
% \file        : siv_ue2.m
% \date        : 30.09.2018
% \version     : 1.0
%******************************************************************************

%%
clear all; clc
format shorteng

syms t n
assume(n, 'integer')

T=1;
w0=2*pi/T;

f(t) = piecewise(t>=0 & t<=T/16, 1, t>=7*T/16 & t<= 9*T/16, -1, t>=15*T/16, 1, 0);

a(n) = 2/(pi*n) * (sin(pi/8*n)-sin(pi*n)+sin(7/8*pi*n));
b(n) = 0*n;
a0 = 0;

x = linspace(0, T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:10    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x.*w0) + b(n).*sin(n.*x.*w0);
end
plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(x)); % original Plot

%%
c0_ = 1/T * int(f(t) * exp(-j* 0 *w0*t), t, 0, T)
c1_ = 1/T * int(f(t) * exp(-j* 1 *w0*t), t, 0, T)

%%

Xrms = 1/2;

% klirrfaktor
k = sqrt( (Xrms^2 - abs(c0_)^2 - 2*abs(c1_)^2) / (Xrms^2 - abs(c0_)^2) )

vpa(k)
%%
% Aufgabe 2)

clear all; clc
format shorteng

syms t n
assume(n, 'integer')

T=2*pi;
w=2*pi/T;

d1 = 1;
d3 = 3;
D = 1;

Vin(t) = D*cos(w*t);
f(t) = d1*Vin(t) + d3*Vin(t)^3;

a(n) = 2/T * int(f(t)*cos(w*t*n), t, 0, T);
b(n) = 2/T * int(f(t)*sin(w*t*n), t, 0, T);
pretty(simplify(a(n)))
pretty(simplify(b(n)))

a0 = 0;

%%
close all
x = linspace(0, T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
plot(x, f(x)); hold on;
plot(x, Vin(x));











