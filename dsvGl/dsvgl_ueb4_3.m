

clear all; clc; format shorteng


syms z 


X = z/(z^2-z-1);
X_z = X/z;
X_z = partfrac(X_z, z, 'Factormode', 'full');
pretty(X_z)






%%

clear all; clc; format shorteng
syms z 
X_z = 1/sqrt(5) * ( 1/(z-1/2-sqrt(5)/2) - 1/(z-1/2+sqrt(5)/2) );

X = simplify(z*X_z)



%%

% Aufgabe 2

clear all; clc; format shorteng
syms z a

X = z/(z^2-2*a*z + a^2);
X_z = X/z;
X_z = partfrac(X_z, z, 'Factormode', 'full');
pretty(X_z)


