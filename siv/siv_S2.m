clear; clc;
syms x;

T = 2*pi;
w0 = 2*pi/T;

f_x = @(x) (mod(x,T) <= T/16 | mod(x, T) >= 15*T/16) + (-1*(mod(x,T) >= 7*T/16 & mod(x, T) <= T*9/16));

syms n pi;
assume(n, 'integer');

% a0 = 1/pi * int(f_x, 0, 2*pi)
% pretty(a0)
a(n) = 2/T * int(cos(n*w0*x), x, -T/16, T/16) - 2/T * int(cos(n*w0*x), x, 7/16*T, 9/16*T);
an = simplify(a(n))
pretty(an)
a(n) = 2/T * 2*int(cos(n*w0*x), x, 0, T/16) - 2/T * 2*int(cos(n*w0*x), x, 7/16*T, 8/16*T);
% b(n) = 2/T * int(f_x*sin(n*x), x, 0, T);
an = simplify(a(n))
pretty(an)
% bn = simplify(b(n))
% pretty(bn)


%%
clear; clc; close all;
T = 16;
w0 = 2*pi/T;
x = linspace(0, 2*T, 1e3);  %% Periodendauer T anpassen
y = zeros(1, 1e3);

% Fourier Koeffizienten und original Funktion angeben
a0 = 0;
% a = @(n) 2/n * (2*sin(n*pi/16) - 2*sin(pi*n)*cos(1/8*pi*n));
% a = @(n) 2/(T*n*w0) *( 2*sin(n*w0*T/16) -2*sin(n*w0*T/2)*cos(n*w0*T/16) );
% a = @(n) 2/n *( sin(pi/8*n) - 2*sin(15/16*pi*n)*cos(pi/16*n) );
a = @(n) 2/(pi*n) * (sin(pi/8*n) - sin(pi*n) + sin(7/8*pi*n));
% a = @(n) (5734161139222659*(sin((pi*n)/8) + sin((7*pi*n)/8)))/(9007199254740992*n);
%a = @(n) -(5734161139222659*cos((pi*n)/4)^2*sin((pi*n)/8)^3*(sin((pi*n)/8)^2 - 1))/(281474976710656*n);
b = @(n) 0*n;
f_x = @(x) (mod(x,T) <= T/16 | mod(x, T) >= 15*T/16) + (-1*(mod(x,T) >= 7*T/16 & mod(x, T) <= T*9/16));

% a0 = pi^2/3;
% a = @(n) -2/(n^2)*(1+(-1)^n);
% b = @(n) n^0 -1;
% f_x = @(x) abs(x).*(pi-abs(x));


for m=1:1e3
    y(m) = a0/2; % a0 setzen
end

for n=1:5    % Anzahl Glieder in der Summierkette
    y = y + a(n).*cos(w0.*n.*x) + b(n).*sin(w0.*n.*x);
    ak = a(n)
end

plot(x, y);    % Fourier Plot
hold  on;
plot(x, f_x(x)); % original Plot
grid on

