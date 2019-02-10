



clear; clc; close all; format shorteng;

w = linspace(1e-2, 40, 1e2);
X = abs(1./(1+w.^6));

p = plot(w, X);

hold on;
grid on;

% plot(w, 2./w);

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')