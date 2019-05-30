%******************************************************************************
% \details     : WST Lebensdauer von Neonröhren
% \autor       : Simon Burkhardt
% \file        : wst_experiment_3_neonroehren.m
% \date        : 23.02.2019
%******************************************************************************
clear all; close all; clc
format shorteng

data = [24 39 45 51 55 62 64 65 67 76 123];
data = sort(data);
n = length(data);

x_ = mean(data)      % Mittelwert
sx = std(data)       % Standardabweichung

% Quartile
Q50 = median(data)   % Median
Q25 = quantile(data, 0.25)  % 0.25 Quartil
Q75 = quantile(data, 0.75)  % 0.75 Quartil
% Q50 = 62.0000e+000
% Q25 = 46.5000e+000
% Q75 = 66.5000e+000
% % % stimmen nicht mit Abbildung 1.3.i überein
% % % Q25 = 45;
% % % Q75 = 67;

% Quartilsweite und Ausreissergrenzen (Kapitel 2.5.2)
dQ = Q75 - Q25;
A_unten = Q25 - 1.5*dQ
A_oben  = Q75 + 1.5*dQ

%%
figure(1)
boxplot(data, 'orientation', 'horizontal', 'whisker', 1.5)
% Die Whisker werden von Matlab an den falschen Orten Platziert, auch mit
% Verlängerung auf 3 stimmen diese nie mit den berechneten Grenzen überein
xlabel('Ausfälle nach x Monaten')
ylabel('')

% Beschriftung der Grenzen
text(Q50, 0.9, strcat('\uparrow Q50 = ', {' '}, num2str(Q50)))
text(Q25, 1.25, strcat('\downarrow Q_{0.25} =', {' '}, num2str(Q25,4)))
text(Q75, 1.35, strcat('\downarrow Q_{0.75} =', {' '}, num2str(Q75,4)))
text(A_unten, 1.15, strcat('\downarrow A_{unten} =', {' '}, num2str(A_unten,4)))
text(A_oben, 1.15, strcat('\downarrow A_{oben} =', {' '}, num2str(A_oben,4)))

% Grenzen genau markieren
hold on;
plot(data, 0.75.*ones(1,length(data)), 'o');
text(Q25, 0.7, 'Messpunkte')

plot(Q50, 1.1, '*')
plot(Q25, 1.1, '*')
plot(Q75, 1.1, '*')
plot(A_oben, 1.1, '*')
plot(A_unten, 1.1, '*')

