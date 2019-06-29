%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : sww_Kap6_aufg2h.m
% \date        : 29.03.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;

m = 0.02;
F = 64;
h = 507e-6;
k = F/h;


% a)
w0 = sqrt(k/m);

% b)
Q = 2*pi*(100/20);
kap = -w0*log(1-2*pi/Q)/sqrt(16*pi^2+log(1-2*pi/Q)^2);

% c)
t05 = -log(0.5)/kap;

% d)
A = 7.5e-6;
w = 2*pi*300;
F0 = A*m*sqrt((w0^2-w^2)^2 +4*kap^2*w^2);

% e)
phi = atan2d(2*kap*w,(w0^2-w^2));

% f)
Ares = F0/m * 1/(2*kap*sqrt(w0^2-kap^2));

% g)
wres = sqrt(w0^2 - 2*kap^2);
dif_proz = (1-wres/w0)*100;

%%
% h)
A = @(w) F0 ./ (m.*sqrt((w0.^2-w.^2).^2 +4.*kap.^2.*w.^2));
w = linspace(1500, 3500, 1e3);
Aw = A(w);

plot(w, Aw); hold on; grid on;
plot(wres, Ares, 'o');
plot([1500, 3500], [Ares/sqrt(2), Ares/sqrt(2)]);

wmin = 0;
for w=0:wres
    if A(w) > Ares/sqrt(2)
        wmin = w;
        break
    end
end

wmax = wres;
for w=wres:3500
    if A(w) < Ares/sqrt(2)
        wmax = w;
        break
    end
end

plot(wmin, A(wmin), 'o');
plot(wmax, A(wmax), 'o');
B = wmax-wmin
Q_ = wres/B




