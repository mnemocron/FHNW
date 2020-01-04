



clear all; clc;
format shorteng;

Sm = 1;
wm = 1;

St = 2;
wt = 10;

t = linspace(0,14,1e3);

sm = Sm*(sin(wm*t) + 1/3*sin(3*wm*t));
%plot(t,sm)

phi = 0;
st = St*sin(wt*t+phi);
sd = st.*sm;

phi = pi/2;
st = St*sin(wt*t+phi);

sdd = st.*sm;

plot(t,sd); hold on;
plot(t,sdd);














