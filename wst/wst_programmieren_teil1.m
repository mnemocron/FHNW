%******************************************************************************
% \details     : WST Teil 1 Programmieren
% \autor       : Simon Burkhardt
% \file        : wst_programmieren_teil1.m
% \date        : 11.04.2019
%******************************************************************************
clear all; close all; clc
format shorteng

% Glücksrad, 3 Felder
% 10 Tipps, 10 Spiele


% r = [2,3,5,10,20, 50, 100];
r = linspace(1,100, 100);


Z = 100;
mu_k = zeros(1,length(r));
sig_k = zeros(1,length(r));

for y=r(1):length(r)
    n = 1e3;
    sta = zeros(1,11);
    for k=1:n
        t = randi([1 r(y)], 1, 10);
        g = randi([1 r(y)], 1, 10);
        sta(sum(t==g)+1) = sta(sum(t==g)+1) +1;
    end

    % plot(linspace(0,10,11), sta);
    pp = sta/n;
    xi = linspace(0,10,11);
    mu = xi*pp';
    sig = ((xi-mu).^2)*pp';
    
    mu_k(y) = mu;
    sig_k(y) = sig;
end

p = 1./r;

plot(p, mu_k); hold on
hold on
plot(p.*(1-p), sig_k); hold on
