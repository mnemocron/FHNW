



clear all; clc; format shorteng


syms z 


H = z^2/(z^2-z+1/2);


H_z = H/z;
H_z = partfrac(H_z, z, 'Factormode', 'full');
pretty(H_z)



