%**************************************************************************
% \details     : WST Formelsammlung
% \autor       : Simon Burkhardt
% \file        : wst_Formelsammlung.m
% \date        : 01.03.2019
%**************************************************************************
clear all; clc; close all;
format shorteng;

% HISTOGRAM
raw = [48, 38, 10, 4];
xval = []
for n=1:length(raw)
    xval = [xval ones(1, raw(n)).*(n-1)];
end
histogram(xval)
xlabel('Tage mit x Ausfällen')
ylabel('Anzahl Tage')
title('Häuffigkeit der Ausfalltage')

% MEDIAN
Q50 = median(data)
% QUARTILE / QUANTILE
Q25 = quantile(data, 0.25) 
Q75 = quantile(data, 0.75) 
% Quartilsweite und Ausreissergrenzen (Kapitel 2.5.2)
dQ = Q75 - Q25;
A_unten = Q25 - 1.5*dQ
A_oben  = Q75 + 1.5*dQ

% MITTELWERT
mean(data)
% STANDARDABWEICHUNG
std(data)

%%
% BOXPLOT
figure(1)
boxplot(data, 'orientation', 'horizontal', 'whisker', 1.5)
xlabel('Ausfälle nach x Monaten')
ylabel('')
title('Ausfallquote von Neonröhren')
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
% einzelne Messpunkte
plot(Q50, 1.1, '*')
plot(Q25, 1.1, '*')
plot(Q75, 1.1, '*')
plot(A_oben, 1.1, '*')
plot(A_unten, 1.1, '*')
%%
% KLASSEN aus vielen Datenpunkten
messung = [404 413 390 418 387 418 399 392 399 417 390 384 ...
    383 387 389 391 411 422 371 369 411 405 408 349 402 378 ...
    393 424 403 414 367 407 383 401 388 386 427 411 400 412 ...
    426 392 402 392 373 390 396 408 386 396];
messung = sort(messung);

n = length(messung);  % Datenpunkte
k = sqrt(n)           % Anzahl Klassen ~~
k = 9;                % runden & wählen
x_min = min(messung)
x_max = max(messung)
x_min = 345;          % wählen
x_max = 435;          % wählen
d = (x_max - x_min)/k

liste = [];
klassen = [];
for a=1:k
    g_unten = x_min + (a-1)*d;
    g_oben = x_min + (a)*d;
    klassen(a) = length(messung( messung>=g_unten & messung<g_oben ));
    [g_unten g_oben klassen(a)];
end
klassen'

%%

% PERMUTATION
% n Elemente auf n! verschiedene Arten anordnen
% n!  =  factorial(n)
% P(n) = n!
Pn = factorial(n)

% KOMBINATORIK
% nchoosek(n, k)

%                | ohne Wiederholung        | mit Wiederholung
% -------------------------------------------------------------------------
% Kombination    | C(n;k) = nchoosek(n, k)  | Cw(n;k) = nchoosek(n+k-1, k)
% k-ter Ordnung  |                          | 
% -------------------------------------------------------------------------
% Variation      | V(n;k) = n! / (n-k)!     | Vw(n;k) = n^k
% k-ter Ordnung  |                          | (3)
% -------------------------------------------------------------------------
%
% (3) n Lose, k Ziehungen


%%
% WAHRSCHEINLICHKEIT

% A?B   A und  B
% AuB   A oder B

P = nGuenstig / nMoeglich

% n-Versuche um auf den selben günsigen Fall zu hoffen
P = n*P

% n-Versuche im Selben Raum
% P = [ P(A) + P(B) - P(A?B) ] / P(S)

P1 = P1
P2 = P1+P1 - P1*P1
P3 = P1+P2 - P1*P2
P4 = P1+P3 - P1*P3

%% Wahrscheinlichkeit 1 Ereignis = 0.1
% Wahrscheinlichkeit 10 Ereignisse hintereinander auf mindestens 1 Erfolg
% (vgl. Ölbohrung)
P = 0;
P1 = 0.1;
for n=1:10
    P = P1 + P - P1*P;
end
P














