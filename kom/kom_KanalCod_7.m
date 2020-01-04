%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : kom_KanalCod_7.m
% \date        : 03.01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format short;
n = 7;
k = 4;

%   [1 X  X^3]
g = [1 1 0 1];      % Generatorpolynom g(X) = 1 + X + X^3

% a) Bestimmen Sie die systematischen Codewörter für die Nachrichtenwörter 
u1 = [0 0 0 1];      % Nachricht u = (1000)
u2 = [0 0 1 0];
u3 = [0 1 0 0];
u4 = [1 0 0 0];

X3 = [0 0 0 1];      % warum X^3  ?

[q,b1] = gfdeconv(gfconv(u1, X3), g);
[q,b2] = gfdeconv(gfconv(u2, X3), g);
[q,b3] = gfdeconv(gfconv(u3, X3), g);
[q,b4] = gfdeconv(gfconv(u4, X3), g);

% Arrays bei höherer Ordnung mit 0 auffüllen für flip
if(numel(b1)<(n-k))
    b1(n-k) = 0;
end
if(numel(b2)<(n-k))
    b2(n-k) = 0;
end
if(numel(b3)<(n-k))
    b3(n-k) = 0;
end
if(numel(b4)<(n-k))
    b4(n-k) = 0;
end

% Order ist verkehrt, darum flip
c1 = [1 0 0 0 flip(b1)]
c2 = [0 1 0 0 flip(b2)]
c3 = [0 0 1 0 flip(b3)]
c4 = [0 0 0 1 flip(b4)]

%%
% b) Wie lautet die systematische Form der Generatormatrix des Codes? 
G = gf([c1;c2;c3;c4])


%%
% c)  Erstellen Sie eine Tabelle mit allen 2k = 16 Codewörtern 
% und überzeugen Sie sich davon, dass 
% der Code tatsächlich zyklisch ist. 
clc;
for idx=0:(2^k-1)
   u = gf((de2bi(idx)));
   if(length(u)<(k))
        u(k) = 0;
   end
   u = flip(u);
   v = u*G;
   disp([strcat(num2str(u.x)), " = ", strcat(num2str(v.x))])
   
end










