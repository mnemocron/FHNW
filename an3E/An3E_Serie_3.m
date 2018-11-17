%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_3.m
% \date        : 06.10.2018
% \version     : 1.0
%******************************************************************************
%% Aufgabe 1

clear all; clc
format shorteng

syms x n
assume(n, 'integer')

T = 2*pi;
w0 = 2*pi/T;
f(x) = abs(x);

a0 = 2/T * int(f(x), x, -T/2, T/2)
pretty(simplify(a0))

a(n) = 2/T * int(f(x)*cos(n*w0*x), x, -T/2, T/2)
pretty(simplify(a(n)))
b(n) = 0*n;

%%
close all;
T = 2*pi;
x = linspace(0, T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben
a0 = pi;
a = @(n) (2*(-1)^n-2)/(n^2*pi)
% a = @(n) -4/pi * 1/((2*n+1)^2);
% b = @(n) 0*n;
% f_x = @(x) abs(x).*(pi-abs(x));

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:3    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x) + b(n).*sin(n.*x);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, abs(x)); % original Plot

%%
% Aufgabe 2
clear; clc;
close all;
T = 2*pi;
x = linspace(0, 3*T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben
a0 = 2;
a = @(n) (2*(-1)^n-2)/(n^2*pi)
a = @(n) 1/(n^2);
b = @(n) 1;

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:200    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x) + b(n).*sin(n.*x);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, abs(x)); % original Plot

%%
% Aufgabe 3
clear all; clc
format shorteng

syms x n
assume(n, 'integer')

T = 4;
w0 = 2*pi/T;
f(x) = piecewise(x>=-2 & x< -1, 0, x>=-1 & x<=0, -3-3*x, x<=1 & x>0, 3-3*x, x<=2 & x>1, 0);
% ungerade
a0 = 2/T * int(f(x), x, -T/2, T/2)
pretty(simplify(a0))

a(n) = 2/T * int(f(x)*cos(n*w0*x), x, -T/2, T/2)
pretty(simplify(a(n)))
b(n) = 2/T * int(f(x)*sin(n*w0*x), x, -T/2, T/2)
pretty(simplify(b(n)))

%%
close all;
x = linspace(-T/2, T/2, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben


for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:10    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x) + b(n).*sin(n.*x);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(x)); % original Plot

%%
% Patrice_Funktion
syms x n
T = 4;
f(x) = piecewise(x>=-2 & x< -1, 0, x>=-1 & x<=0, -3-3*x, x<=1 & x>0, 3-3*x, x<=2 & x>1, 0);

lsg = fourieranalysis_patrice(f, T, -T/2, true, true)



%%
% Aufgabe 4
clear all; clc;
syms x n;
assume(n, 'integer');

f = @(x) exp(x);
T = 2*pi;
w = 2*pi/T;

c0_ = 1/T * int(f, x, 0, T);
c(n) = 1/T * int(f*exp(-j*w*n*x), x, 0, T);

pretty(simplify(c))
pretty(simplify(c(0)))
pretty(simplify(c0_))

%%
clc;
a0 = 2*c0_;
a(n) = 2*real(c);
b(n) = 2*imag(c);

a_is = vpa(simplify(a), 5)
a0_is = vpa(simplify(a(0)), 5)
a0_is = vpa(simplify(a0), 5)
b_is = vpa(simplify(b), 5)

%%
% Aufgabe 5
clear all; clc;
syms x n;
assume(n, 'integer');

T = 2*pi;
w = 2*pi/T;
f = piecewise(x>0 & x<=T/2, x, x>T/2 & x<=T, T-x, 0);

% fplot(f, [0, T])

%%
format shorteng
clear all;
syms x n T;
assume(n, 'integer');

w = 2*pi/T;
f = piecewise(x>0 & x<=T/2, x, x>T/2 & x<=T, T-x, 0);
c(n) = 1/T * int(f*exp(-j*w*n*x), x, 0, T);

pretty(vpa(simplify(c), 7))

%                      n       2
%   0.0253303 T ((-1.0)  - 1.0)
% - ----------------------------
%                 2
%                n

for n=1:10
    cn2pi(n) = vpa(norm(subs(c(n), T, 2*pi)));
end

cn2pi'

for n=1:10
    cn4pi(n) = vpa(norm(subs(c(n), T, 4*pi)));
end

cn4pi'










