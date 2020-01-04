%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_gf2_Generatormatrix.m
% \date        : 01.01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format short;
k = 3;             % Nachrichtenbits
n = 7;             % Codewortlänge
m = n-k;           % m Prüfbits
Ik = gf(eye(k));   % Eihneitsmatrix

% 7.1 Systematische Form einer Generatormatrix
% Beispiel Buch p. 59

% https://www.mathworks.com/help/comm/ug/working-with-galois-fields.html
% Generatormatrix
disp("Generatormatrix G")
G = gf([1 0 0 1 1 1 0;
        0 1 0 0 1 1 1;
        0 0 1 1 1 0 1])

% Prüfmatrix - Buch p. 60
disp("Teilmatrix P der Generatormatrix")
P = G(1:k, k+1:end)  % Generatormatrix ohne Einheitsmatrix
% G = [Ik, P]          % Kontrolle: G = [I_k + P]

PT = P';             % transponiert
disp("Prüfmatrix H")
H = [PT, eye(n-k)]   % Prüfmatrix H = [PT + I_{n-k}]

% Syndrom muss 0 sein
disp("Syndrommatrix s")
s = H*G'

%% Beispiel
clc;
u = gf([1 0 1]);  % Nachricht
disp("gesendetes Codewort v")
v = u*G

% fehlerfreie Übertragung (Fehlermuster e = 0)
e = gf(zeros(1,n));
disp("empfangenes Codewort r")
r = v+e;
% ist r ein gültiges Codewort?
disp("Syndrom s")
s = r*H'        % Syndromvektor

% Übertragungsfehler
e(1) = 1;    % bitflip (+ --> xor)
r = v+e;
% ist r ein gültiges Codewort?
s = r*H'        % Syndromvektor

%% Decodierung
% Buch p. 61
clear; clc;
k = 4;             % Nachrichtenbits
n = 7;             % Codewortlänge
m = n-k;           % m Prüfbits
Ik = gf(eye(k));   % Eihneitsmatrix
% Generatormatrix
G = gf([1 0 0 1 1 1 0;
        0 1 0 0 0 1 1;
        0 0 1 1 1 1 1;
        0 0 0 1 1 0 1])
% Prüfmatrix
P = G(1:k, k+1:end); % Generatormatrix ohne Einheitsmatrix
PT = P';             % transponiert
H = [PT, eye(n-k)]   % Prüfmatrix H = [PT + I_{n-k}]

% Empfangen wird r
r = gf([1 0 0 1 0 0 1]);
s = r*H'             % Syndromvektor

%% weiteres Vorgehen:
% - alle möglichen Fehlermuster e finden
% - das Fehlermuster mit dem kleinsten Hamming-Gewicht
e = gf([0 0 0 0 0 1 0]);
% best guess:
vs = e+r



