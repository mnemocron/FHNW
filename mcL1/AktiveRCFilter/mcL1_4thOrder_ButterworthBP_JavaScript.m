

clear all;
clc; format shorteng

C = 10e-9;
fl = 950;
fu = 1050;
k = 1;

% fm = sqrt(fu*fl);
% B = fu - fl;

fm = 1e3;
B = 100;

Qbp = fm/B;

% butterworth n = 2
a = 0.7071;
b = 0.7071;

var1 = (a^2 + b^2);
var2 = 2*a/Qbp;
var3 = var1/(Qbp^2) +4;
var4 = sqrt(var3^2 - 4*var2^2);
Q = sqrt((var3+var4) / (2*var2^2));
var6 = a*Q/Qbp;
var7 = var6 + sqrt(var6^2 -1);
Fra = fm/var7;
Frb = fm*var7;

gain = sqrt(k);

y = (fm/Fra) - Fra/fm;
y = y^2;
Ar = gain*sqrt(1+ Q^2 *y);

R3 = Q/(pi*Fra*C)
R1 = R3/(2*Ar)
R2 = R3/2 / (2*Q^2 -Ar)

y = (fm/Fra) - Fra/fm;
y = y^2;
Ar = gain*sqrt(1+ Q^2 *y);

R6 = Q/(pi*Frb*C)
R4 = R6 / (2*Ar)
R5 = R6/2 / (2*Q^2 -Ar)



