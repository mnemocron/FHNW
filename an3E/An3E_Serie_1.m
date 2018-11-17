%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_1.m
% \date        : 22.09.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

%%
% 1)
syms x;

f_a = log(x+1);
f_a_dx = diff(f_a, x);
% 1/(x + 1)

f_b = 1/2 * asin(x)^2;
f_b_dx = diff(f_b, x)
% asin(x)/(1 - x^2)^(1/2)

f_c = -1/4 * (x-1)^4;
f_c_dx = diff(f_c, x)
% -(x - 1)^3

%% 
% 2)
clear; clc;
syms x t;

f_a = (1-t)^3;
Ff_a_t = int(f_a, t)
% -(t - 1)^4/4

f_b = exp(x)*cos(t);
Ff_b_x = int(f_b, x)
%exp(x)*cos(t)

f_c = f_b;
Ff_c_t = int(f_c, t)
%exp(x)*sin(t)

f_d = x^2*exp(-x);
Ff_d_x = int(f_d, x)
% -exp(-x)*(x^2 + 2*x + 2)
lsg_d = int(f_d, x, 0, 10)
% 2 - 122*exp(-10)


%%
% Serie 1b

%%
% 2)
clear; clc;
syms x n pi;
assume(n, 'integer');

f_x = abs(x) * (pi - abs(x));
a0 = 1/pi * int(f_x, x, -pi, pi)
% vpa(a0)

%a(n) = 1/pi * int(abs(x) * (pi - abs(x))*cos(n*x), x, -pi, pi);
%simplify(a(n))
%                 abs(x) * (pi - abs(x))
a(n) = 1/pi * int(f_x                   *cos(n*x), x, -pi, pi);
an = simplify(a(n))
pretty(an)

b(n) = 1/pi * int(f_x                   *sin(n*x), x, -pi, pi);
bn = simplify(b(n))
pretty(bn)



%%
clear; clc;
syms x n pi;
assume(n, 'integer');

f_x = x;

a0 = 1/pi * int(f_x, x, 0, 2*pi)

a(n) = 1/pi * int(f_x * cos(n*x), x, 0, 2*pi);
b(n) = 1/pi * int(f_x * sin(n*x), x, 0, 2*pi);

an = simplify(a(n))
pretty(an)

bn = simplify(b(n))
pretty(bn)


%%
clear; clc;
syms x;

f_x = x^2;
%ezplot(f_x, [0, 2*pi]);

syms n pi;
assume(n, 'integer');

a0 = 1/pi * int(f_x, 0, 2*pi)
pretty(a0)
a(n) = 1/pi * int(f_x*cos(n*x), x, 0, 2*pi);
b(n) = 1/pi * int(f_x*sin(n*x), x, 0, 2*pi);
an = simplify(a(n))
pretty(an)
bn = simplify(b(n))
pretty(bn)

%%
clear; clc; close all;
x = linspace(0, 3*pi, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);

% Fourier Koeffizienten und original Funktion angeben
a0 = 8*pi^2/3;
a = @(n) 4/(n^2);
b = @(n) -4*pi/n;
f_x = @(x) mod(x, 2*pi).^2;

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));


for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:10    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(n.*x) + b(n).*sin(n.*x);
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f_x(x)); % original Plot









