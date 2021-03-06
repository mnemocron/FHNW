% @file         Formelsammlung_lalg1.m
% @brief        Formelsammlung Lineare Algebra 1 (lalg1)
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-01-30
% @copyright    unlicense.org

% MATLAB
clear; clc;
format LONG;        % mehr Nachkommastellen
format SHORT;
hold ON;            % multiple Plots
hold OFF;
% Funktion plotten
fplot(fx, [0,10])   % plottet von 0 bis 10
% Achsen anschreiben
xlabel('x');
ylabel('y');
% Ab wann k�nnen kleine Zahlen als 0 angesehen werden?
eps     % Info �ber maximale Genauigkeit der verwendeten Hardware
d=[-5 1 -1 -1; -1 3 1 1; -6 1 -2 -2; 4 -4 2 2]
det(d)  % man erwartet eine Determinante > 1 --> Determinante = 0
inv(d)  % mit Ungenauigkeitswarnung -> gibt keine Inverse

% Radiant / Grad
rad2deg(pi)
deg2rad(180)

% Gr�sse / Anzahl Elemente
length(y)
size(y)          % Anzahl Elemente
size(y,2)

% Gleichungen vereinfachen
collect(x^2*y + y*x -x^2-2*x)

% Solve
syms x y;
fun1 = y == 3*x + 4;
fun2 = y^2 - x^2 - (10*x/3) + 13/3 == 0;
S = solve(fun1,fun2)
[Sx,Sy] = solve(fun1, fun2)

% Polarkoordinaten / karthesische Koordinaten
[radius, phi] = cart2pol(x, y);
[x,y] = pol2cart(radius, phi);


% Gerade aus zwei Punkten (2-Dimensional)
% Koordinatenform: y = m*x + c
% a => 1. Punkt (Kleinere x-Komponente)
% b => 2. Punkt (Gr�ssere x-Komponente)
% Achtung: a und b m�ssen in Spaltenform vorliegen!
m = (b(2)-a(2))/(b(1)-a(1))
c = a(2)-(m*a(1))

m = (b.y-a.y)/(b.x-a.x)
c = (a.y-(m*a.x))

% Gerade aus Punkt + Richtungsvektor
x = [2 1]';
r = [1 0]';
m = r(2)/r(1)
c = x(2)-(m*x(1))

% Quadratische Interpolation
% Parabel durch drei Punkte (2-Dimensional)
p = [-1; 3];
q = [0; 10];
r = [1; 13];
M = [p(1)^2 p(1) 1 p(2); q(1)^2 q(1) 1 q(2); r(1)^2 r(1) 1 r(2)];
% M=[p.x^2 p.x 1 p.y; q.x^2 q.x 1 q.y; r.x^2 r.x 1 r.y];
params = rref(M)
% nun erh�lt man die Parameter a, b, c f�r die Parabelgleichung:
% a*x^2 + b*x + c = 0
% Test:
fx = @(x) params(1,4)*(x.^2) + params(2,4)*(x) + params(3,4)
hold on;
fplot(fx);
plot(p(1), p(2), '*');
plot(q(1), q(2), '*');
plot(r(1), r(2), '*');

% lineare Abh�ngigkeit
% Kollinearit�t / Komplanarit�t
a = [-3; 2]; b = [4; -6];
M = [a b];
rref(M);
% Wenn in der Diagonalen nur 1-en sind, 
% so sind die Vektoren linear unabh�ngig
% Besteht die letzte Zeile (oder mehr) nur aus 0
% so sind die Vektoren kollinear / komplanar

% Test: Kollinearit�t
b = [1 1]';
a = [2 2]';
dot(b, (a/norm(a))) == norm(b)   % ACHTUNG: Rundungsfehler

% Test: Komplanarit�t
dot(a, (cross(b, c))) == 0    % ACHTUNG: Rundungsfehler

% Normalenvektor n bestimmen
n = cross(a,b)
norm(n)     % Fl�che des aufgespannten Parallelogramms a, b
norm(n)/2   % Fl�che des aufgespannten Dreiecks a, b

% Linearkombination zum Nullvektor
u = [-5 1 1]';
v = [2 1 1]';
w = [3 5 5]';
M = [u v w];
% rref(M)      % Check: sind linear abh�ngig?
% r=null(M)
r = null(M, 'r')
% Der Nullvektor ist folglich:
r(1)*u + r(2)*v + r(3)*w      % muss [0 0 0]' geben

% Diskretisierung
% Lineare Abh�ngigkeit von Funktionen
fx = @(x) (x+4).^2;
gx = @(x) -(x+2).*(x+6)-4;
hx = @(x) -(x+2).*(x+6);
params=[-4 -2 4];
M = [fx(params); gx(params); hx(params)];
rref(M);       % zeigt, ob die Funktionen linear abh�ngig sind oder nicht
% auch hier k�nnte null(M, 'r') angewendet werden
% Orthogonal-Basis:
% stehen zwei Vektoren senkrecht zueinander, so ist deren Skalarprodukt = 0
M'*M

% Interpolation
% Gegeben: - Funktionen
%          - Stellen (x)
%          - Funktionswerte (y)
stellen = [5 6 7 8]';
werte = [0, 22, -44, -198]';
f1 = @(x) (x-8).*(x-7).*(x-6);
f2 = @(x) (x-8).*(x-7).*(x-5);
f3 = @(x) (x-8).*(x-6).*(x-5);
f4 = @(x) (x-7).*(x-6).*(x-5);
% diskretisieren mit den Funktionen als Spalte und Stellen als Zeile
dis=[f1(stellen) f2(stellen) f3(stellen) f4(stellen)];
% Parameter a1 = dot(y, f1)/(norm(f1)^2)
a1 = dot(werte, dis(:,1))/(norm(dis(:,1))^2)
a2 = dot(werte, dis(:,2))/(norm(dis(:,2))^2)
a3 = dot(werte, dis(:,3))/(norm(dis(:,3))^2)
a4 = dot(werte, dis(:,4))/(norm(dis(:,4))^2)
% so heisst die Interpolation:
% f(x) = a1*f1 + a2*f2 + a3*f3 + a4*f4

% Diskretisierung / Interpolation
stellen=[0 5/4 5/2 15/4 5 25/4 15/2 35/4]';
werte=[0 105 150 165 168 165 150 105]';
f1=@(x) ((x./5)-1).^0;
f2=@(x) ((x./5)-1).^1;
f3=@(x) ((x./5)-1).^2;
f4=@(x) ((x./5)-1).^3;
f5=@(x) ((x./5)-1).^4;
f6=@(x) ((x./5)-1).^5;
f7=@(x) ((x./5)-1).^6;
f8=@(x) ((x./5)-1).^7;
dis=[f1(stellen) f2(stellen) f3(stellen) f4(stellen) f5(stellen) f6(stellen) f7(stellen) f8(stellen)]
%  Orthogonalit�t Pr�fen
dis'*dis        % keine senkrechte Orthogonalit�t ( = 0)
% Interpolation
aa=inv(dis)*werte;
ff=@(x) aa(1).*f1(x) + aa(2).*f2(x) + aa(3).*f3(x) + aa(4).*f4(x) + aa(5).*f5(x) + aa(6).*f6(x) + aa(7).*f7(x) + aa(8).*f8(x);


% Orthogonalbasistransformation:
% Vektor s zur neuen Basis F
% s1f = dot(f1./(norm(f1)^2), s)
s = [1 11 -2]';
f1 = [2 1 2]';
f2 = [-2 2 1]';
f3 = [1 2 -2]';
s1f = dot(f1./(norm(f1)^2), s);
s2f = dot(f2./(norm(f2)^2), s);
s3f = dot(f3./(norm(f3)^2), s);
sf = [s1f s2f s3f]'

% Basistransformation
f1 = [3/5 -4/5]';     % Basisvektoren (vorzugsweise normiert)
f2 = [4/5 3/5]';
F = [f1 f2];          % Basis-Matrix
A = [12 -1]';         % Vektor A
% mit Projektion:
a1f = dot(A, f1./(norm(f1)^2));
a2f = dot(A, f2./(norm(f2)^2));
Af = [a1f; a2f]
% mit Basis-Matrix:
Af = inv(F)*A

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vektoren

% L�nge eines Vektors |a|
norm(a);

% Skalarprodukt (Winkel zwischen Vektoren)
% Skalarprodukt:
% der vordere Vektor muss eine Zeile sein,
% der hintere Vektor muss eine Spalte sein !
a=[-1 1]';      % in Spaltenform
b=[2 2]';
a'*b            % Vektoren in Spaltenform
a*b'            % Vektoren in Zeilenform
dot(a, b)       % alternativ

acosd( dot(a, b)/ (norm(a)*norm(b)) )
atan2d(norm(cross(a,b)),dot(a,b))    % alternativ (nur f�r 3D Vektoren)


% Schatten
% Die L�nge des Schattens von b auf a ist:
a = [0 5]';
b = [-1 9]';
f = dot(b, a)/norm(aa)
% Hinweise: 
%   - L�nge des Schattens ist immer betragsm�ssig anzugeben
%   - f�r Projejtion/Lot/Spiegelung => ff mit Vorzeichen angeben
%   - Winkel zwischen a / b:  f > 0  =>   < 90 deg
%                             f < 0  =>   > 90 deg

% Die Projektion von b in Richtung a ist:
fba = ( dot(b, a)/norm(a) ) *a/norm(a)


% Test: Liegt ein Punk B auf der Geraden A+lambda*v:
A = [0 1 0]'; v=[1 1 0]';
B = [2 3 0]';
norm( cross(v, B-A) ) == 0   % ACHTUNG: Rundungsfehler

% Abstand Punkt -> Gerade
h = norm( cross(v, B-A) ) / norm(v)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MATRIZEN
% E1: |     -2y       =  2 | 
% E2: | 4x  -4y  +12z = 20 | 
% E3: | 2x        +6z =  8 | 
M = [0 -2 0; 4 -4 12; 2 0 6];
u = [10 -1 -2]';
M*u       % muss [2 20 8]' geben


% LINEARES GLEICHUNGSSYSTEM L�SEN (LGS)
% Rang eines Linearen Gleichungssystems:
% R = Anzahl nicht-trivialer Gleichungsn (0x=0) nach Durchf�hrung
% des Gauss-Verfahrens.
% n ist die Anzahl an Unbekannten im LGS.
% A ist die Koeffizientenmatrix
% b ist die Erweiterung zur erweiterten Koeffizientenmatrix (L�sungen)
% Ein System n linearer Gleichungen in n Unbekannten ist entweder
% eindeutig, nicht eindeutig oder �berhaupt nicht l�sbar.
% rank(A) = rank ([A,b]) < n : unendlich viele L�sungen
% rank(A) < n und rank(A) nicht gleich rank([A,b]) : keine L�sung L={/}
% rank(A) = n : eindeutige L�sung
rank(A)
rank([A,b])
% Freie Variablen = Anzahl Variablen - Rang
% Pivot Variablen = Rang

% Vorgehen:
% 1. LGS mit Gauss in Stuffenform bringen  -> rref()
% 2. Pivot Variablen finden
%       f�r jede Zeile jeweils die vorderste Variable die nicht 0 ist
% 3. Freie Variablen (n - Rang) jeweils die �brigen nicht-Pivot Variablen
% 4. Aufpunkt finden: Alle freien Variablen = 0 und LGS l�sen
% 5. nacheinander eine freie Variable = 1, die anderen = 0
%       und das LGS nach 0 aufl�sen
% 6.     x             x1         x2
%     L (y) = P + lam*(y1) + del*(y2) + ...
%        z             y2         z2
%        .              .          .

A = [0 0 2 0 0; 1 1 -4 1 0; 3 3 -12 3 1];
b = [4 2 7]';
rank(A)
rank([A,b])
gauss = rref([A,b])
% --> x, z, v  sind Pivot Variablen
% --> y, u     sind freie Variablen
gauss(1,2) = 0; gauss(2,2) = 0; gauss(3,2) = 0;    % y=0
gauss(1,4) = 0; gauss(2,4) = 0; gauss(3,4) = 0;    % u=0
% Aufpunkt: P=[10 0 2 0 1]';
A\b    % Aufpunkt berechnen

% Aufpunkt f�r quadratische Matrix:
% Ansatz:   dot(A, l�sung) == b
% aufl�sen nach l�sung
% inv(A)*b

% mit MATLAB:
A = [0 0 2 0 0; 1 1 -4 1 0; 3 3 -12 3 1];
b = [4 2 7]';
% 1. Herausfinden, ob es unendlich viele L�sungen gibt:
rank(A)
rank([A,b])
% rank(A) == rank([A,b]) < n : unendlich viele L�sungen
% 2. Aus rref(A) den Aufpunkt herauslesen (bestimmen)
% dazu die freien Variablen = 0 setzen
% p=rref([A,b])
p = A\b;
% p(1,freie)=0; p(2,freie)=0; usw....
% 3. mit null() die Richtungsvektoren (homogene L�sunen) bestimmen
null(A, 'r')


% Begriffe:
% Homogen:      gehen durch den Ursprung (Ebenen)
%               0 ist immer eine L�sung eines homogenen LGS
% Inhomogen:    weichen vom Ursprung ab
% Konsistent:   es existiert eine L�sung
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
% Abbildungen mit Matrix

% Test: ist die Abbildung linear?
syms x y m n k;
L = @(v1,v2) [3*v1-4*v2; v1+5*v2];   % Abbildung
% Vortest:
nullvektor = L(0, 0) % muss [0, 0] ergeben sonst ist die Abbildung nicht linear.

% Homogenit�t pr�fen
diff = L(k*x, k*y) - k*L(x, y);
homogen = collect(diff)         
% Wenn das Resultat [0, 0] ist, ist die Abbildung homogen.

% Additivit�t pr�fen
diff = L(x+m, y+n) - (L(x, y) + L(m, n) );
additiv = collect(diff)
% Wenn das Resultat [0, 0] ist, ist die Abbildung additiv.



% Drehung um phi am Ursprung
e1s = [ cos(phi); sin(phi)];
e2s = [-sin(phi); cos(phi)];
R = [e1s e2s];
R = [cos(phi) -sin(phi); sin(phi) cos(phi)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ebenengleichungen
P = [2 1 -3]';
Q = [3 0 2]';
R = [2 2 1]';

% Parameterform:
% E:x = OP + r*PQ + s*PR
% P + lam*(Q-P) + phi*(R-P)
PQ = Q-P;
PR = R-P;

% Normalenform
% A: Aufpunkt / x: Punkt der auf der Ebene liegt / n: Normale
% E: (x-A)*n
% (x-P)*n
n = cross(PQ, PR);

% Koordinatenform
% a*x + b*y + c*z = d
a = n(1);
b = n(2);
c = n(3);
d = abs( P(1)*n(1) + P(2)*n(2) + P(3)*n(3) );

% Hessesche Normalform
% x: Punkt auf Ebene / |n|: normierte Normale / d: Abstand zum Ursprung
% x*|n| = d

% Achsenabschnittsform
% x/x0 + y/y0 + z/z0 = 1
x0 = d/a;
y0 = d/b;
z0 = d/c;

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

% Einermatrix in der doppelten Dreiecksfunktion
eye(3)
eye(4,8)

% Liste mit Doppelpunkt / linspace
x=1:10      % 1 bis 10
x=1:2:10    % 1 bis 10 im Abstand von 2
x=linspace(1,10,5)  % von 1 bis 10 mit 5 Elementen

