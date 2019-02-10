%%
% a)
clear all; clc; close all;

w = linspace(1e-2, 1e2, 1e4);
% X = sinc(w./2);
X = w./(w.^2 + 3.*w + 1);

p = plot(w, X);

hold on;
grid on;

plot(w, 1./w, 'r')
plot(w, w.*0+1/3, 'r')
plot(w, w./1, 'r')

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')


%%
% b)
clear all; clc; close all;

s = linspace(1e-3, 1e4, 1e4);
X = (s.^3) ./ (s.^2 + 17.*s + 5);

as1 = s;
as2 = s.^2./17;
as3 = s.^3./5;

p = plot(s, X);

hold on;
grid on;

plot(s, as1, 'r')
plot(s, as2, 'r')
plot(s, as3, 'r')

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

%%
% c)
clear all; clc; close all;

s = linspace(1e-3, 1e3, 1e6);
X = 1./(s.^2 - 5.*s + 20);

as1 = 1./(s.^2);
as2 = 1./(5.*s);
as3 = 1/20 + s.*0;

p = plot(s, X);

hold on;
grid on;

plot(s, as1, 'r')
plot(s, as2, 'r')
plot(s, as3, 'r')

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

%%
% c)
clear all; clc; close all;

s = linspace(1e-3, 1e3, 1e6);
X = (s.^2)./(s.^2 + 25);

as1 = 1 + s.*0;
as2 = (s.^2)./25;

p = plot(s, X);

hold on;
grid on;

plot(s, as1, 'r')
plot(s, as2, 'r')

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')




