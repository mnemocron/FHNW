% @file         lalg1_Serie8_6_7.m
% @brief        Aufgabe: Diskretisierung und Interpolation
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-02-03
% @copyright    unlicense.org
% @see          http://adams-science.com/wp-content/uploads/lineare_algebra01/serie_08_interpolation02_aufg.pdf
% @see          http://adams-science.com/wp-content/uploads/lineare_algebra01/serie_08_interpolation02_los.pdf

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

F=[f1(stellen) f2(stellen) f3(stellen) f4(stellen) f5(stellen) f6(stellen) f7(stellen) f8(stellen)]
% Aufgabe 6: Orthogonalität Prüfen
F'*F        % keine senkrechte Orthogonalität

% Aufgabe 7: Interpolation
aa=inv(F)*werte;
ff=@(x) aa(1).*f1(x) + aa(2).*f2(x) + aa(3).*f3(x) + aa(4).*f4(x) + aa(5).*f5(x) + aa(6).*f6(x) + aa(7).*f7(x) + aa(8).*f8(x);

fplot(ff, [0,10]);
hold on;
plot(stellen(1), werte(1), '*');
plot(stellen(2), werte(2), '*');
plot(stellen(3), werte(3), '*');
plot(stellen(4), werte(4), '*');
plot(stellen(5), werte(5), '*');
plot(stellen(6), werte(6), '*');
plot(stellen(7), werte(7), '*');
plot(stellen(8), werte(8), '*');


