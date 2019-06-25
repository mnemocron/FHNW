%**************************************************************************
% \details     : WST Serie 10
% \autor       : Simon Burkhardt
% \file        : wst_serie_10.m
% \date        : 06.2019
%**************************************************************************


%%
% 1.
clear all; close; clc; format shorteng;

x = [8, 9, 11, 10, 10];
xbar = mean(x)
sx2 = std(x)^2
n = length(x);
alpha = 0.01;
mu = 10; % 10E

% Transformation der Abweichung vom Mittelwert
ttest = (xbar - mu)/sqrt(sx2)*sqrt(n)
% Bestimmung der kritischen Gr?osse zum Signifikanzniveau ?= 0.01. 
% Zweiseitige Fragestellung. n= 5?1 = 4. Wir lesen aus der Tabelle aus
tcrit = tinv(1-alpha/2, n-1)
% Statistischer Schluss
if(abs(ttest)>=tcrit)
    disp("H0 verwerfen")
else
    disp("H0 annehmen")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))

