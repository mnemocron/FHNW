
clear all; clc; close all;

w = linspace(0.1, 40, 1e4);
% X = sinc(w./2);
X = sin(w./2).*2./w;

p = plot(w, X);

hold on;
grid on;

plot(w, 2./w);

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
