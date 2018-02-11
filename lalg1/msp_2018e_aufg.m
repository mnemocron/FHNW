% Name      Burkhardt Simon
% Nr        04
% Klasse    1Ea

% Aufg 1: Gegenseitige Lage (10)
% 3x + y -z-152 = 0
% h: [x,y,z]'=[410 141 -101]'+ mu* [ 1 1 4 ]'

% Gegenseitige Lage von E und h
% Schnittpunkt:

% Kommentar: 
% der untere Lösungsweg ist falsch, funktioniert nicht:
% % % syms x y z mu
% % % gl1 = 3*x + y -z -152 == 0;
% % % gl2 = [x,y,z]' == [410 141 -101]'+ mu* [ 1 1 4 ]';
% % % los = solve([gl1,gl2]);
% % % % todo, funktioniert nicht
% % % % Aufpunkt suchen:
% % % Aa = [50 3 1]';     % 3*50 +3 -1 -152 = 0
% % % % Abstand: Aufpunkt h -> Ebene
% % % hh = [410 141 -101]';
% % % nn = [3 1 -1]';
% % % hh = dot((hh-Aa), nn./norm(nn)) % Abstand
% % % mu = hh/norm([ 1 1 4 ])
% % % Ss = [410 141 -101]' + mu* [ 1 1 4 ]'

% Ab hier ist der Lösungsweg korrekt:
% Test Aufpunkt der Gerade in Ebene:
% Aufpunkt suchen:
Aa = [50 3 1]';     % 3*50 +3 -1 -152 = 0
Bb = [410 141 -101]';
nn = [3 1 -1]';
dot(Bb-Aa, nn./norm(nn))
% ans =
%   397.9950        % = Abstand des Aufpunktes der Gerade zur Ebene

% Die Gerade und die Ebene Schneiden sich nicht
% weil der Aufpunkt der Gerade ausserhalb der Ebene liegt, und
% die Gerade h parallel zur Ebene verläuft

% Schnittwinkel:
nn = [3 1 -1]';     % normalen der Ebene
Rh = [1 1 4]';      % richtungsvektor der Geraden h
acosd( dot(nn, Rh)/ (norm(nn)*norm(Rh)) )
% ans =
%     90
% Die Gerade h liegt parallel zur Ebene E (senkrecht zur Normalen)

% Abstand:
% Test Punkt in Ebene:
% Aufpunkt suchen:
Aa = [50 3 1]';     % 3*50 +3 -1 -152 = 0
Bb = [410 141 -101]';
nn = [3 1 -1]';
dot(Bb-Aa, nn./norm(nn))
% ans =
%   397.9950
% Der Abstand ist also 397.995
 

% Aufg 2. Interpolation (8)
Ss=[  -78, 52]' ; 
P=[ -60, 700]';
% P kann an Ss gespiegelt werden --> Q
Q=[Ss(1)-P(1)+Ss(1), 700]'
% Q =
%    -96
%    700
M = [Ss(1)^2 Ss(1) 1 Ss(2); Q(1)^2 Q(1) 1 Q(2); P(1)^2 P(1) 1 P(2)];
params = rref(M)
% params =
%            1           0           0           2
%            0           1           0         312
%            0           0           1       12220
% nun erhält man die Parameter a, b, c für die Parabelgleichung:
% f(x) = 2x^2 + 312x + 12220
% Test: 
fx = @(x) params(1,4)*(x.^2) + params(2,4)*(x) + params(3,4)
hold on;
fplot(fx);
plot(Ss(1), Ss(2), '*');
plot(P(1), P(2), '*');
plot(Q(1), Q(2), '*');


% Aufg 3. Inverse und Determinante (10)
syms a
Pp= [ -2*a-63 , -21*a-4 , -2*a-21 ;
      7*a+189 , 63*a+14 , 7*a+63 ;
       3 , a-4 , a+1 ];
gl=det(Pp)      % muss 0 sein
solve(gl==0)
% ans =
%          0
%   14^(1/2)
%  -14^(1/2)

% Test:
a = 0;
subs(gl)    % = 0
a=14^(1/2);
subs(gl)    % = 0
a=-14^(1/2);
subs(gl)    % = 0
% Lösungsmenge a = {-14^(1/2), 0, 14^(1/2)}


% Aufg 4. Lineare Abbildungen (10)
% a) Lla=@(x) [ x ; x-1 ; x ]
% linear ja/nein?
% Matrix Mm= [ ]
syms x y z m n k;
Lla=@(x) [ x ; x-1 ; x ]
% Vortest mit 0-Vektor
Lla(0)      % muss 0 ergeben
% ans =
%      0
%     -1
%      0
% Die Abbildung ist also nicht linear

% b) Cc=[-8 16] ; Dd=[-1 2]' 
Cc=[-8 16]'; 
Dd=[-1 2]'; 
CD = Dd - Cc;
% m = (Dd(2)-Cc(2))/(Dd(1)-Cc(1))
% c = Cc(2)-(m*Cc(1))

% Die Projektion von e in Richtung CD ist:
e1 = [1 0]';
e2 = [0 1]';
e1f = ( dot(e1, CD)/norm(CD) ) *CD/norm(CD)
e2f = ( dot(e2, CD)/norm(CD) ) *CD/norm(CD)
Nn = [e1f e2f]
% Nn =
%     0.2000   -0.4000
%    -0.4000    0.8000
syms x y z m n k;
Llb = @(v1,v2) [0.2*v1 -0.4*v2; -0.4*v1 +0.8*v2];
% Vortest:
nullvektor = Llb(0, 0) % muss [0, 0] ergeben sonst ist die Abbildung nicht linear.

% Homogenität prüfen
diff = Llb(k*x, k*y) - k*Llb(x, y);
homogen = collect(diff)         
% Wenn das Resultat [0, 0] ist, ist die Abbildung homogen.
% homogen =
% [ 0, 0]
% [ 0, 0]
% ist homogen

% Additivität prüfen
diff = Llb(x+m, y+n) - (Llb(x, y) + Llb(m, n) );
additiv = collect(diff)
% additiv =
% [ 0, 0]
% [ 0, 0]
% ist additiv

% (ja) Die Matrix Nn ist linear
% Nn =
%     0.2000   -0.4000
%    -0.4000    0.8000

% c) Dd=[-1 2]'
clear
clc
Dd=[-1 2]';
phi=deg2rad(60);
e1s = [ cos(phi)-1; sin(phi)];
e2s = [-sin(phi); cos(phi)+2];
Pp = [e1s e2s];
% Pp = [cos(phi) -sin(phi); sin(phi) cos(phi)];
a=[1 0]
b=Pp*a'
hold on
% plot(0, 0, '*');
% plot(a, '*');
% plot(b, '*');
% plot(Dd, '*');

% linear ja/nein?
% nein. Die Matrix ist nicht linear, da, für das einsetzen eines 
% Nullvektors kein Nullvektor herauskommt (wird gedreht um 60° mit
% Radius = norm([-1; 2])
% (Beweis fehlt hier, ich erinnere mich jedoch noch an den Unterricht
% und kann mir die Rotation um den Punkt D vorstellen)

% Matrix Pp= [ ]
% Mögliche Lösung für Pp:
% (jedoch nicht verifiziert)
phi=deg2rad(60);
e1s = [ cos(phi)-1; sin(phi)];
e2s = [-sin(phi); cos(phi)+2];
Pp = [e1s e2s];

% Aufgabe 5
e1=[21 -56 54 28 -4]
e2=[-21 56 54 56 -4]
e3=[-6 16 -90 -66 7]
A=[e1; e2; e3]
b=[235 529 -595]';
% rank(A) = rank ([A,b]) = 3 < n=5 : unendlich viele Lösungen
rref(A)
% ans =
%       u         v         x         y         z
%     1.0000   -2.6667         0   -0.6667         0
%          0         0    1.0000    0.7778         0
%          0         0         0         0    1.0000
% Pivot Variablen: u x z
% Freie Variablen: v y
AufP = A\b    % Aufpunkt berechnen
% AufP =
%          0
%     2.6250
%     7.0000
%          0
%    -1.0000
% mit null() die Richtungsvektoren (homogene Lösunen) bestimmen
null(A, 'r')
% ans =
%     2.6667    0.6667
%     1.0000         0
%          0   -0.7778
%          0    1.0000
%          0         0
% Lösung: 
% [u v x y z] = 
% [0 2.625 7 0 -1]' + lamda*[2.6667 1 0 0 0]' + rho*[0.6667 0 -0.7778 1 0]'



% Aufg 6 Impedanzen
Rr=1 ; % in Ohm
Cc=700*10^(-9) ;  % in F
Ll=100*10^(-9) ; % in H
ud= 39.2 % in V
ff=590*10^3 % in Hz

% a) Matrix der Gesamtimpedanz
clear
syms Rr Ll Cc w
Zr = [Rr 0; 0 Rr];
Zl = [0 w*Ll; -w*Ll 0];
Zc = [0 -1/(w*Cc); 1/(w*Cc) 0];
Zt= inv(inv(Zl)+inv(Zc))+Zr
% Zt =
% [                     Rr, -(Ll*w)/(Cc*Ll*w^2 - 1)]
% [ (Ll*w)/(Cc*Ll*w^2 - 1),                      Rr]

% oder numerisch: (von Aufgabe c)
% Zt =
%     1.0000    9.7479
%    -9.7479    1.0000

% b) Quellspannung in Zeigerform
ud= 39.2 % in V
uu = [0 ud]';

% c) Strom in Zeigerform
% iv = subs(inv(Zt))*uu     % ergibt Terme mit zu grossen Zahlen
% Darum das ganze nocheinmal, ohne syms
clear
Rr=1 ; % in Ohm
Cc=700*10^(-9) ;  % in F
Ll=100*10^(-9) ; % in H
ff=590*10^3 % in Hz
w = 2*pi*ff;
Zr = [Rr 0; 0 Rr];
Zl = [0 w*Ll; -w*Ll 0];
Zc = [0 -1/(w*Cc); 1/(w*Cc) 0];
Zt= inv(inv(Zl)+inv(Zc))+Zr
ud= 39.2 % in V
uu = [0 ud]';
% iv = subs(inv(Zt))*uu     % ergibt Terme mit zu grossen Zahlen
iv = inv(Zt)*uu
% iv =
%    -3.9795
%     0.4082
   
ii = norm(iv)
% ii =
%     4.0004

% d)
phi = atan(iv(1)/iv(2))         % in rad
phid = atand(iv(1)/iv(2))
% phid =
%   -84.1428       % in ° (Grad)

% i(t)= ii * sin( w* t + phid)
% i(t) = 4A * sin(w*t -84.1428°)





