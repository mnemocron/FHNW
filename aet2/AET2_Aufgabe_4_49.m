% Aufg 4-49

clear; clc; close all;

Up=sqrt(2)*230;
f=50; w=2*pi*f; T=1/f;
t=linspace(0, 2.5*T, 1e3);
U1M=Up*cos(w*t);
U2M=Up*cos(w*t+deg2rad(-120));
U3M=Up*cos(w*t+deg2rad(120));

UM=U1M+U2M+U3M;

plot(t, U1M); hold on
plot(t, U2M); grid on
plot(t, U3M);
plot(t, UM);

legend(["U1M", "U2M", "U3M", "UM"])





