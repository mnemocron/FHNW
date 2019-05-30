



clear all; clc; format shorteng

r = 0.8;
rho = pi/3;

k = linspace(0, 1e2, 1e3);
x = r.^(k-1).*sin(rho.*k)./sin(rho);

plot(k, x); hold on;
rho = 2*pi/3;
x = r.^(k-1).*sin(rho.*k)./sin(rho);
plot(k, x);


%%

% Aufg 2 b)

clear all; clc; format shorteng


syms z 


H = (z^2 -z +1)/((z+1/3)*(z-1/2));


H_z = H/z;
H_z = partfrac(H_z, z, 'Factormode', 'full');
pretty(H_z)






