%%
clear all; close all; clc; format shorteng

syms x

f(x) = piecewise(0<x>=2, 3/2*x-1, 2<x<=pi, -1, 0);

lsg = four_an(f, pi, 0);

lsg.c

%%
clear all; close all; clc; format shorteng

syms x n
assume(n, 'integer')

f(x) = piecewise(-pi<=x<-pi/2, -pi/2, -pi/2<=x<pi/2, x, pi/2<=x<pi, pi/2, 0);

lsg = four_an(f, 2*pi, -pi);


%%
clear all; close all; clc; format shorteng

syms s w x y f(x)
lsg = ilaplace( (-2*s^2 + 18*s - 3)/(s^3 - s^2 -8*s + 12)  )


%%
clear all; close all; clc; format shorteng

syms a s t w x F(t)
lsg = laplace(3*(sin(2*t))^2-4)

%%
clear all; close all; clc; format shorteng

syms s w x y f(x)
lsg = ilaplace( (s+2)/(s^2 + 4*s + 29) )
pretty(simplify(lsg))


%%

clear all; close all; clc
format shorteng
syms x y z

f = (x*y-1)/(x^2);

fx = diff(f, x, 1);
pretty(simplify(fx))
fy = diff(f, y, 1);
pretty(simplify(fy))
x0 = 2; 
y0 = 3;
z0 = subs(f, [x y], [x0 y0])

f_Ebene = z - z0 == subs(fx, [x y], [x0 y0])*(x-x0) ...
    + subs(fy, [x y], [x0 y0])*(y-y0)

%%
clear all; close all; clc; format shorteng

x = -1:0.1:1;
y = -1:0.1:1;
[X Y] = meshgrid(x,y);
Z = (X.*Y-1)./(X.^2);
subplot(2,1,1);
mesh(X,Y,Z);
subplot(2,1,2);
contour(X,Y,Z, 30);
grid on


%%
clear all; close all; clc
format shorteng

x = linspace(-10, 10, 1e3);
y = -x - 1./x;

plot(x, y)
grid on
axis([-10 10 -10 10])

