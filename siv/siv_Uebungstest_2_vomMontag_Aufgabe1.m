clear all; clc; close all;

s = linspace(1e-1, 1e3, 1e6);

T1 = s;
T2 = 1./(1+s);
T3 = 1./(1+1./6.*s);
T4 = 1+1./10.*s;

k = 1.11111;

T = k*T1.*T2.*T3.*T4;

% X = s./(1+s)./(1+1./6.*s).*(1+1./10.*s);

as1 = s;
as2 = s.^0;
as3 = 1./(1./6.*s);
as4 = (0.6).*s.^0;

p = plot(s, T);
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

hold on;
grid on;

plot(s, T1, 'r')
plot(s, T2, 'r')
plot(s, T3, 'r')
plot(s, T4, 'r')

% plot(s, as1, 'b')
% plot(s, as2, 'b')
% plot(s, as3, 'b')
% plot(s, as4, 'b')


%%

s = tf('s');
% H = (s^2)/(s^2 - 1 - 1/36*s^4);
% H = (s^2)/(- 1 - 1/36*s^4 + 100/36*s^2);
% H = (s^4)/(s^3 - s^4 - 1/6*s^5 - 6*s^4);

% H = s/(1+s)/(1+1/6*s)*(1+1/10*s);
H = 1.111*s*(1+1/10*s)/(1+s)/(1+1/6*s);

bodeplot(H); grid on;


