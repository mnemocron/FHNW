%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_Generatormatrix_sysForm_rref.m
% \date        : 01.01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format short;

% 7.1 Systematische Form einer Generatormatrix
% Beispiel Buch p. 59
g1 = [1 1 0 1 0 0 1];
g2 = [1 0 1 0 0 1 1];
g3 = [1 0 0 1 1 1 0];
% Generatormatrix
G = [g1; g2; g3];

% Systematische Form
% g2rref: https://gist.github.com/esromneb/652fed46ae328b17e104
Gunit = g2rref(G)

% Linearkombination aus dem Buch
Gunit = [g3; xor(g1, g3); xor(g2, g3)]


%%
% Prüfmatrix
k = 3;
n = 7;
Ik = eye(3);   % Eihneitsmatrix
P = Gunit(1:k, k+1:end)  

Gunit = [Ik, P]; % G = [Ik + P]

PT = P';
H = [PT, eye(n-k)]

% Test
xor(H', Gunit)


