% @file         lalg1_Serie8_4_5.m
% @brief        Aufgabe: Diskretisierung und Interpolation
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-02-03
% @copyright    unlicense.org
% @see          http://adams-science.com/wp-content/uploads/lineare_algebra01/serie_08_interpolation02_aufg.pdf
% @see          http://adams-science.com/wp-content/uploads/lineare_algebra01/serie_08_interpolation02_los.pdf

f0 = @(x) x.^0;
f1 = @(x) x.^1;
f2 = @(x) x.^2;
f3 = @(x) x.^3;
f4 = @(x) x.^4;
f5 = @(x) x.^5;
f5 = @(x) x.^5;
stellen = [0 1/6 1/3 1/2 2/3 5/6]';
werte = [0 1 2 3 2 1]';

F = [f0(stellen) f1(stellen) f2(stellen) f3(stellen) f4(stellen) f5(stellen)];
% Aufgabe 4: Orthogonalität prüfen:
F'*F

% Aufgabe 5: Interpolation
% Koeffizienten berechnen
aa = inv(F)*werte;

% Zum fploten:
% ff = @(x) aa(1) + aa(2).*x + aa(3).*x.^2 + aa(4).*x.^3 + aa(5).*x.^4 + aa(6).*x.^5;
ff = @(x) aa(1).*f0(x) + aa(2).*f1(x) + aa(3).*f2(x) + aa(4).*f3(x) + aa(5).*f4(x) + aa(6).*f5(x);

fplot(ff, [0,1]);
hold on;
plot(stellen(1), werte(1), '*');
plot(stellen(2), werte(2), '*');
plot(stellen(3), werte(3), '*');
plot(stellen(4), werte(4), '*');
plot(stellen(5), werte(5), '*');
plot(stellen(6), werte(6), '*');


