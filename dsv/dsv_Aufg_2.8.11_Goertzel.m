%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_2.8.11_Goertzel.m
% \date        : 10.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

fS=8000;
TS=1/fS;
N = 2^14;
k = 0:N-1;
t = k*TS;
f0 = 697;
x = cos(2*pi*t*f0) + randn(size(t));

% plot(t,x)
% soundsc(x, fS);

f = (fS)/N*(0:N-1);
devi = 0.05;  % 5% deviation von der Mittenfrequenz
indxs = find(f>(f0*(1-devi)) & f<(f0*(1+devi)));
X = goertzel(x, indxs);


%%
% b)

% Berechnung vom Effektivwert ist sicher FALSCH !
Eff = sqrt(sum(abs(X)))



%%

% c)

plot(f(indxs)/1e3,   20*log10(abs(X)/length(X)));
hold on;
plot(f0/1e3, 32, 'o');
hold off;
title('Mean Squared Spectrum');
xlabel('Frequency (kHz)');
ylabel('Power (dB)');
grid on;
set(gca,'XLim',[f(indxs(1)) f(indxs(end))]/1e3);
set(gca, 'YLim', [-20, 40]);

%%
figure(2)
pwelch(x);



