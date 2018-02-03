% @file         lalg1_Serie10.m
% @brief        
% @author       Burkhardt Simon - github.com/mnemocron
% @date         2018-02-03
% @copyright    unlicense.org
% @see          http://adams-science.com

p = [-2 -3]';
q = [-1 1]';
r = [0 1]';
s = [1 1]';
t = [2 -3]';

% Es sind 5 Punkte gegen, also hat das Interpolationspolynom 5 Koeffizienten
% p(t)=c0+c1*t+c2*t2+c3*t3+c4*t4

f1=@(x) x.^0;
f2=@(x) x.^1;
f3=@(x) x.^2;
f4=@(x) x.^3;
f5=@(x) x.^4;

stellen=[p(1) q(1) r(1) s(1) t(1)]';
werte=[p(2) q(2) r(2) s(2) t(2)]';

F=[f1(stellen) f2(stellen) f3(stellen) f4(stellen) f5(stellen)];
aa=inv(F)*werte;
ff=@(x) aa(1).*f1(x) + aa(2).*f2(x) + aa(3).*f3(x) + aa(4).*f4(x) + aa(5).*f5(x);

fplot(ff, [-2,2]);
hold on;
plot(stellen(1), werte(1), '*');
plot(stellen(2), werte(2), '*');
plot(stellen(3), werte(3), '*');
plot(stellen(4), werte(4), '*');
plot(stellen(5), werte(5), '*');

% Aufgabe 3
% Orthogonalbasistransformation:
% Vektor s zur neuen Basis F
% s1f = dot(f1./(norm(f1)^2), s)
s = [1 11 -2]';
f1 = [2 1 2]';
f2 = [-2 2 1]';
f3 = [1 2 -2]';
s1f = dot(f1./(norm(f1)^2), s)
s2f = dot(f2./(norm(f2)^2), s)
s3f = dot(f3./(norm(f3)^2), s)



