% @file         Formelsammlung_lalg_1.m
% @brief        Formelsammlung Lineare Algebra 1 (lalg1)
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-01-27
% @copyright    

% MATLAB
clear; clc;
format LONG;        % mehr Nachkommastellen
format SHORT;
hold ON;            % multiple Plots
hold OFF;
% Achsen anschreiben
xlabel('x')
ylabel('y')

% Radiant / Grad
rad2deg(pi)
deg2rad(180)

% Polarkoordinaten / karthesische Koordinaten
[radius, phi] = cart2pol(x, y);
[x,y] = pol2cart(radius, phi);


% Gerade aus zwei Punkten (2-Dimensional)
% Koordinatenform: y = m*x + c
% a => 1. Punkt (Kleinere x-Komponente)
% b => 2. Punkt (Grössere x-Komponente)
% Achtung: a und b müssen in Spaltenform vorliegen!
m = (b(2)-a(2))/(b(1)-a(1))
c = a(2)-(m*a(1))

m = (b.y-a.y)/(b.x-a.x)
c = (a.y-(m*a.x))

% Quadratische Interpolation
% Parabel durch drei Punkte (2-Dimensional)
p=[-1; 3];
q=[0; 10];
r=[1; 13];
M=[p(1)^2 p(1) 1 p(2); q(1)^2 q(1) 1 q(2); r(1)^2 r(1) 1 r(2)];
% M=[p.x^2 p.x 1 p.y; q.x^2 q.x 1 q.y; r.x^2 r.x 1 r.y];
params=rref(M)
% nun erhält man die Parameter a, b, c für die Parabelgleichung:
% a*x^2 + b*x + c = 0
% Test:
fx=@(x) params(1,4)*(x.^2) + params(2,4)*(x) +params(3,4)
hold on;
fplot(fx);
plot(p(1), p(2), '*');
plot(q(1), q(2), '*');
plot(r(1), r(2), '*');

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

% Normalenvektor n bestimmen
n = cross(a,b)
norm(n)     % Fläche des aufgespannten Parallelogramms a, b
norm(n)/2   % Fläche des aufgespannten Dreiecks a, b

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

% Funktion plotten
fplot(fx, [0,10])   % plottet von 0 bis 10

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
% rank(A) < n und rank(A) nicht gleich rank([A,b]) : keine Lösung L={/}
% rank(A) = n : eindeutige Lösung
rank(A)
rank([A,b])
% Freie Variablen = Anzahl Variablen - Rang

% Vorgehen:
% 1. LGS mit Gauss in Stuffenform bringen  -> rref()
% 2. Pivot Variablen finden
%       für jede Zeile jeweils die vorderste Variable die nicht 0 ist
% 3. Freie Variablen (n - Rang) jeweils die übrigen nicht-Pivot Variablen
% 4. Aufpunkt finden: Alle freien Variablen = 0 und LGS lösen
% 5. nacheinander eine freie Variable = 1, die anderen = 0
%       und das LGS nach 0 auflösen
% 6.     x             x1         x2
%     L (y) = P + lam*(y1) + del*(y2) + ...
%        z             y2         z2
%        .              .          .

A=[0 0 2 0 0; 1 1 -4 1 0; 3 3 -12 3 1];
b=[4 2 7]';
rank(A)
rank([A,b])
aa=rref([A,b])
% --> x, z, v  sind Pivot Variablen
% --> y, u     sind freie Variablen
aa(1,2)=0; aa(2,2)=0; aa(3,2)=0;    % y=0
aa(1,4)=0; aa(2,4)=0; aa(3,4)=0;    % u=0
% Aufpunkt: P=[10 0 2 0 1]';

% mit MATLAB:
A=[0 0 2 0 0; 1 1 -4 1 0; 3 3 -12 3 1];
b=[4 2 7]';
% 1. Herausfinden, ob es unendlich viele Lösungen gibt:
rank(A)
rank([A,b])
% rank(A) == rank([A,b]) < n : unendlich viele Lösungen
% 2. Aus rref(A) den Aufpunkt herauslesen (bestimmen)
% dazu die freien Variablen = 0 setzen
p=rref([A,b])
% p(1,freie)=0; p(2,freie)=0; usw....
% 3. mit null() die Richtungsvektoren (homogene Lösunen) bestimmen
null(A, 'r')


% Begriffe:
% Homogen:      gehen durch den Ursprung (Ebenen)
%               0 ist immer eine Lösung eines homogenen LGS
% Inhomogen:    weichen vom Ursprung ab
% Konsistent:   es existiert eine Lösung
% Inkonsistent: 


% Inverse Matrix
% Nach Gauss-Jordan Verfahren
% Gauss:  Dreiecksform unten links
% Jordan: Dreiecksfrom oben  rechts
inv(M)
M*inv(M)  % muss Diagonale 1-en ergeben

% Determinante
det(M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Abbildungen mir Matrix

% Drehung um phi am Ursprung
e1s=[ cos(phi); sin(phi)];
e2s=[-sin(phi); cos(phi)];
R=[e1s e2s];
R=[cos(phi) -sin(phi); sin(phi) cos(phi)];

% Test: Linearität der Matrix
% Homogenität: L(lam*v) = lam*L(v)
% Additivität: L(v+w) = L(v)+L(w)
% @todo:



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




