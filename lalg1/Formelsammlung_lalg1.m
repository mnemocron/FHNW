% @file         Formelsammlung_lalg_1.m
% @brief        Formelsammlung Lineare Algebra 1 (lalg1)
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-01-26
% @copyright    License: WTFPL

% MATLAB
clear; clc;
format LONG;        % mehr Nachkommastellen
format SHORT;
% Achsen anschreiben
xlabel('x')
ylabel('y')

% Radiant / Grad
rad2deg(pi)
deg2rad(180)

% Polarkoordinaten / karthesische Koordinaten
[radius, phi] = cart2pol(x, y);
[x,y] = pol2cart(radius, phi);


% lineare Abhängigkeit
% Kollinearität / Komplanarität
a=[-3; 2]; b=[4; -6];
M=[a b];
rref(M);
% Wenn in der Diagonalen nur 1-en sind, 
% so sind die Vektoren linear unabhängig
% Besteht die letzte Zeile (oder mehr) nur aus 0
% so sind die Vektoren kollinear / komplanar

% Test: Kollinearität
b=[1 1]';
a=[2 2]';
dot(b, (a/norm(a))) == norm(b)   % ACHTUNG: Rundungsfehler

% Test: Komplanarität
dot(a, (cross(b, c))) == 0    % ACHTUNG: Rundungsfehler

% Linearkombination zum Nullvektor
u=[-5 1 1]';
v=[2 1 1]';
w=[3 5 5]';
M=[u v w];
% rref(M)      % Check: sind linear abhängig?
% r=null(M)
r=null(M, 'r')
% Der Nullvektor ist folglich:
r(1)*u + r(2)*v + r(3)*w      % muss [0 0 0]' geben

% Lineare Abhängigkeit von Funktionen
fx = @(x) (x+4).^2;
gx = @(x) -(x+2).*(x+6)-4;
hx = @(x) -(x+2).*(x+6);
params=[-4 -2 4];
M=[fx(params); gx(params); hx(params)];
rref(M);       % zeigt, ob die Funktionen linear abhängig sind oder nicht
% auch hier könnte null(M, 'r') angewendet werden


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vektoren

% Länge eines Vektors |a|
norm(a);

% Skalarprodukt (Winkel zwischen Vektoren)
% Vektoren in Spaltenform:
a=[-1 1]';
b=[2 2]';
% a'*b          % Skalarprodukt (in Spaltenform)
dot(a, b)

acosd( dot(a, b)/ (norm(a)*norm(b)) )
atan2d(norm(cross(a,b)),dot(a,b))    % alternativ (nur für 3D Vektoren)


% Schatten
% Die Länge des Schattens von b auf a ist:
a=[0 5]';
b=[-1 9]';
f=dot(b, a)/norm(aa)
% Hinweise: 
%   - Länge des Schattens ist immer betragsmässig anzugeben
%   - für Projejtion/Lot/Spiegelung => ff mit Vorzeichen angeben
%   - Winkel zwischen a / b:  f > 0  =>   < 90 deg
%                             f < 0  =>   > 90 deg

% Die Projektion von b in Richtung a ist:
fba=( dot(b, a)/norm(a) ) *a/norm(a)


% Test: Liegt ein Punk B auf der Geraden A+lambda*v:
A=[0 1 0]'; v=[1 1 0]';
B=[2 3 0]';
norm( cross(v, B-A) ) == 0   % ACHTUNG: Rundungsfehler

% Abstand Punkt -> Gerade
h=norm( cross(v, B-A) ) / norm(v)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MATRIZEN
% E1: |     -2y       =  2 | 
% E2: | 4x  -4y  +12z = 20 | 
% E3: | 2x        +6z =  8 | 
M=[0 -2 0; 4 -4 12; 2 0 6];
u=[10 -1 -2]';
M*u       % muss [2 20 8]' geben


% Rang eines Linearen Gleichungssystems:
% R = Anzahl nicht-trivialer Gleichungsn (0x=0) nach Durchführung
% des Gauss-Verfahrens.
% n ist die Anzahl an Unbekannten im LGS.
% A ist die Koeffizientenmatrix
% b ist die Erweiterung zur erweiterten Koeffizientenmatrix (Lösungen)
% Ein System n linearer Gleichungen in n Unbekannten ist entweder
% eindeutig, nicht eindeutig oder überhaupt nicht lösbar.
% rank(A) = rank ([A,b]) < n : unendlich viele Lösungen
% rank (A) < n und rank(A) nicht gleich rank([A,b]) : keine Lösung
% rank(A) = n : eindeutige Lösung
rank(A)
rank([A,b])
% Freie Variablen = Anzahl Variablen - Grad

% Begriffe:
% Homogen:      gehen durch den Ursprung (Ebenen)
% Inhomogen:    weichen vom Ursprung ab
% Konsistent:   es existiert eine Lösung
% Inkonsistent: 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weitere Hinweise
% (CTRL + F)

% Abstand Punkt -> Ebene
% Hessesche Normalform
%     / / x \     _ \           _
% E: |  | y |  -  A  |  (dotp)  n   = 0 
%     \ \ z /       /
% n: normiertes Kreutzprodukt der Ebenenvektoren
% A: Aufpunkt in der Ebene
% Einsetzen vom Punkt in die Normalenform gibt den Abstand zur Ebene

% Winkelfrequenz, Periodendauer
% omega = 2*pi*f
% omega = 2*pi/T
% T = 1/f
% T = 2*pi/omega
% ...





