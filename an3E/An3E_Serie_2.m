%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_2.m
% \date        : 30.09.2018
% \version     : 1.0
%******************************************************************************
%% Aufgabe 1

clear all; clc
format shorteng

syms x n
assume(n, 'integer')

T = 2*pi;
w0 = 2*pi/T;
f(x) = x*(2*pi-x);

a0 = 2/T * int(f(x), x, 0, T)
pretty(a0)

a(n) = 2/T * int(f(x)*cos(n*w0*x), x, 0, T)
pretty(a(n))
b(n) = sin(0*n);

%%
close all;
x = linspace(0, 3*T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:10    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x) + b(n).*sin(n.*x);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(mod(x, T))); % original Plot


%% Aufgabe 2

clear all; clc
format shorteng

syms x n
assume(n, 'integer')

T = 2;
w0 = 2*pi/T;
f(x) = piecewise(x<=1 & x>=0, exp(x), x<=0 & x>=-1, -exp(-x), 0);

a0 = 2/T * int(f(x), x, -T/2, T/2)
pretty(a0)

a(n) = 2/T * int(f(x)*cos(n*w0*x), x, -T/2, T/2)
pretty(a(n))
b(n) = 2/T * int(f(x)*sin(n*w0*x), x, -T/2, T/2)
pretty(b(n))

close all;
x = linspace(-T/2, T/2, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:15    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x.*w0) + b(n).*sin(n.*x.*w0);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(mod(abs(x), T).*sign(x))); % original Plot



%%
% Aufgabe 4
clear all; clc
format shorteng
syms x n
assume(n, 'integer')

T = 2*pi;
w0 = 2*pi/T;
f(x) = piecewise(x>=-pi/5 & x<=pi/5, 0, x>=pi/5 & x<=pi, -x+pi, x<=-pi/5 & x>=-pi, x+pi, 0);

a0 = 2/T * int(f(x), x, -T/2, T/2)
pretty(a0)

a(n) = 2/T * int(f(x)*cos(n*w0*x), x, -T/2, T/2)
pretty(a(n))
b(n) = 2/T * int(f(x)*sin(n*w0*x), x, -T/2, T/2)
pretty(b(n))

close all;
x = linspace(-3*pi, 3*pi, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:15    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x.*w0) + b(n).*sin(n.*x.*w0);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(x)); % original Plot

% a(n) = 

%   /                                   / pi n \   \
%   |                           n pi sin| ---- | 4 |
%   |                / pi n \           \   5  /   |
%   | cos(pi n) - cos| ---- | + ------------------ | 5734161139222659
%   \                \   5  /            5         /
% - -----------------------------------------------------------------
%                                            2
%                          9007199254740992 n

% c) Approximieren Sie mit trigonometrischem Polynom
%%
close all;
x = linspace(-3*pi, 3*pi, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);
% Fourier Koeffizienten und original Funktion angeben

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));

% a0 = 4/3*pi^2;
% a(n) = -4/(n^2);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:2    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x.*w0) + b(n).*sin(n.*x.*w0);
end

d1 = vpa(a(1))
d2 = vpa(a(2))
e1 = b(1)
e2 = b(2)

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(x)); % original Plot


%%
% Aufgabe 5)
clear all; clc
format shorteng
syms x n
assume(n, 'integer')

T = 2;
w0 = 2*pi/T;
f(x) = 1 - x^2;


a0 = 2/T * int(f(x), x, -T/2, T/2)
pretty(a0)

a(n) = 2 * int(f(x)*cos(n*w0*x), x, 0, T/2)
pretty(simplify(a(n)))
b(n) = 2/T * int(f(x)*sin(n*w0*x), x, -T/2, T/2)
pretty(simplify(b(n)))

close all;
x = linspace(-T/2, T/2, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);

for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:15    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x.*w0) + b(n).*sin(n.*x.*w0);
end
plot(x, y);    % Fourier Plot
hold  on;
plot(x, f(x)); % original Plot

%%
% M-File aus Lösungen

% 2. Vorlesung

%% Aufgabe 5 

clear all

clc

syms t k n;
assume(n,'integer')
assume(k,'integer')
f(t)=1-t^2;

% f gerade bn=0

% Berechnung der Fourier Koeffizienten
a_0=2*int(f(t),t,0,1)
a(n)=2*int(f(t)*cos(n*pi*t),t,0,1);
a(n)=simplify(a(n))


%Aufstellung der Fourier-Reihe
r(t,k) = a_0/2 + symsum(a(n)*cos(n*pi*t), n, 1, k);


%Berechnung des mittleren quadratischen Fehlers
% F(k) = |f|^2  - |r|^2
F(k) = int(f(t)^2, t, -1, 1) - a_0^2/2 - symsum(a(n)^2, n, 1, k);
double(F(5))
double(F(10))
double(F(18))



















