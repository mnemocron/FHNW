%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_Pseudoprueffung_2.m
% \date        : 03.01.2020
% \version     : 1.0
%******************************************************************************

% Aufgabe 2 - Teil A
% 
clear all; close all; clc;
format short;
k = 7;             % Nachrichtenbits
n = 15;            % Codewortlänge
m = n-k;           % m Prüfbits
Ik = gf(eye(k));   % Eihneitsmatrix

disp("Generatormatrix G")
G = gf([1 0 0 0 0 0 0 1 1 1 0 1 0 0 0;
0 1 0 0 0 0 0 0 1 1 1 0 1 0 0;
0 0 1 0 0 0 0 0 0 1 1 1 0 1 0;
0 0 0 1 0 0 0 0 0 0 1 1 1 0 1;
0 0 0 0 1 0 0 1 1 1 0 0 1 1 0;
0 0 0 0 0 1 0 0 1 1 1 0 0 1 1;
0 0 0 0 0 0 1 1 1 0 1 0 0 0 1])

% d)
% Prüfmatrix
disp("Teilmatrix P der Generatormatrix")
P = G(1:k, k+1:end)  % Generatormatrix ohne Einheitsmatrix
% G = [Ik, P]          % Kontrolle: G = [I_k + P]

PT = P';             % transponiert
disp("Prüfmatrix H")
H = [PT, eye(n-k)]   % Prüfmatrix H = [PT + I_{n-k}]

% Syndrom muss 0 sein
disp("Syndrommatrix s")
s = H*G'

%% Decodierung
% e) 

% irgend ein Codewort
u = gf(ones(1,k));
v = u*G

% Fehlermuster
e = gf(zeros(1,n));
e(1) = 1;

r = v+e;
s = r*H'             % Syndromvektor

%%
% Aufgabe 3

% c)
clear all; close all; clc;
format short;
n = 6;
k = 2;
disp("Generatormatrix G")
G = gf([1 0 1 1 0 1;
        0 1 1 0 1 1])
% Prüfmatrix
P = G(1:k, k+1:end); % Generatormatrix ohne Einheitsmatrix
PT = P';             % transponiert
H = [PT, eye(n-k)]   % Prüfmatrix H = [PT + I_{n-k}]

% irgend ein Codewort
u = gf(ones(1,k));
v = u*G;

% Fehlermuster
e = gf([1 0 0 0 0 0]);
r = v+e;
s = r*H'
e = gf([0 1 0 0 0 0]);
r = v+e;
s = r*H'
e = gf([0 0 1 0 0 0]);
r = v+e;
s = r*H'




