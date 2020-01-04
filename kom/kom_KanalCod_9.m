%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_KanalCod_9.m
% \date        : 03.01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format short;
n = 7;
k = 4;

% a)
g = [1 0 1 1 1]; % 1+x^2+x^3+x^4
gfpretty(g)

%%
% b)
m = n-k

%%
% c) Geben Sie die systematische Generatormatrix des Codes an.
clc
u1 = flip([1 0 0]);      % Nachricht u = (100)
u2 = flip([0 1 0]);
u3 = flip([0 0 1]);

X3 = [0 0 0 0 1];      % warum X^4 ?  --> X^k ?

[q,b1] = gfdeconv(gfconv(u1, X3), g);
[q,b2] = gfdeconv(gfconv(u2, X3), g);
[q,b3] = gfdeconv(gfconv(u3, X3), g);

% Arrays bei höherer Ordnung mit 0 auffüllen für flip
% if(numel(b1)<(n-k))
%     b1(n-k) = 0;
% end
% if(numel(b2)<(n-k))
%     b2(n-k) = 0;
% end
% if(numel(b3)<(n-k))
%     b3(n-k) = 0;
% end
b2(4) = 0;

% Order ist verkehrt, darum flip
c1 = [flip(u1) flip(b1)]
c2 = [flip(u2) flip(b2)]
c3 = [flip(u3) flip(b3)]

G = gf([c1;c2;c3])

%%
% d) Was ist die minimale Hamming-Distanz des Codes? 
clc
% Tabelle berechnen
for idx=0:(2^m-1)
   u = gf((de2bi(idx)));
   if(length(u)<(m))
        u(m) = 0;
   end
   u = flip(u);
   v = u*G;
   disp([strcat(num2str(u.x)), " = ", strcat(num2str(v.x))])
end

%%
% f) Berechnen Sie den Syndromvektor für die empfangenen Binärworte 
% r1 = (1 1 1 0 0 1 1) und 
% r2 = (1 1 0 0 1 0 1). 
k = 3;  % WTF? why tho?

P = G(1:k, k+1:end); % Generatormatrix ohne Einheitsmatrix
PT = P';             % transponiert
H = [PT, eye(n-k)]   % Prüfmatrix H = [PT + I_{n-k}]

r1 = gf([1 1 1 0 0 1 1]);
r2 = gf([1 1 0 0 1 0 1]);

s1 = r1*H'             % Syndromvektor
s2 = r2*H'             % Syndromvektor


