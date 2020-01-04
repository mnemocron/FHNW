%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_gf2_GeneratorPolynom.m
% \date        : 02.01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format short;
n = 7;
k = 4;
% ACHTUNG! Reihenfolge der Parameter !
% [ 1   X   X^2   X^3   ...      X^n ]
% Polynom überprüfen mit gfpretty()

% Beispiel p.67
%   [  X + X^3 ]
u = [0 1 0 1];      % Nachricht u = (1010)
%   [1 X  X^3]
g = [1 1 0 1];      % Generatorpolynom g(X) = 1 + X + X^3

% https://www.mathworks.com/help/comm/ref/gfconv.html
v = gfconv(u, g)
gfpretty(v)
% v =    0     1     1     1     0     0     1
%        0     1     2     3     4     5     6
%              X     X^2   X^3               X^6

%% Codierung
% Beispiel p. 69
% Erzeugen eines systematischen Codes mit gegebenem Generatorpolynom
clear; clc;
n = 7;
k = 4;
%   [1 + X^3 ]
u = [1 0 0 1];      % Nachricht u = (1001)
%   [1 X  X^3]
g = [1 1 0 1];      % Generatorpolynom g(X) = 1 + X + X^3

% 1. u(X) mit X^(n-k) multiplizieren
Xn_k = zeros(1, n-k+1);
Xn_k(n-k+1) = 1;
% Xn_k = [0 0 0 1];   % = X^(7-4) = X^3
% gfconv('1 + x^3', 'x^3')     % funktioniert auch mit Strings
Xu = gfconv(u, Xn_k)
gfpretty(Xu)

% 2. Rest b(X) von X^(n-k)*u(X) / g(X)
[q,r] = gfdeconv(Xu, g);
b = r
gfpretty(b)

% 3. Codewort zusammenbauen X^(n-k)*u(X)  +  b(X)
v = gfadd(Xu, b)
gfpretty(v)

%%
% "copy pasta" / Gegeben (n, k, u, g)
Xn_k = zeros(1, n-k+1); Xn_k(n-k+1) = 1;
Xu = gfconv(u, Xn_k);
[q,b] = gfdeconv(Xu, g);
v = gfadd(Xu, b)


%% Decodierung

% 1. Berechnung des Syndroms 
% 2. Zuordnung des Syndroms zu einem Fehlermuster
% 3. Korrektur des empfangenen Binärwortes 

clear; clc;
n = 7;
k = 4;
%   [1 X  X^3]
g = [1 1 0 1];      % Generatorpolynom g(X) = 1 + X + X^3

% Empfangswert
r = [0 1 1 1 0 0 1];

% Jedes gültige Codewortpolynom ist ohne Rest durch g(X) teilbar
[q,s] = gfdeconv(r,g)
if(s)       % wenn ein Rest übrig bleibt
    disp("Codewort ungültig");
end

% fehlerhafte übertragung
r(1) = r(1)+1;
r(2) = 0;
[q,s] = gfdeconv(r,g)
if(s)       % wenn ein Rest übrig bleibt
    disp("Codewort ungültig");
end







