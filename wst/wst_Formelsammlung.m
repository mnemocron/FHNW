%**************************************************************************
% \details     : WST Formelsammlung
% \autor       : Simon Burkhardt
% \file        : wst_Formelsammlung.m
% \date        : 01.03.2019
%**************************************************************************
clear all; clc; close all;
format shorteng;

% MITTELWERT
mean(data)
% STANDARDABWEICHUNG
std(data)
% MEDIAN
Q50 = median(data)
% QUARTILE / QUANTILE
Q25 = quantile(data, 0.25) 
Q75 = quantile(data, 0.75) 
% Quartilsweite und Ausreissergrenzen (Kapitel 2.5.2)
dQ = Q75 - Q25;
A_unten = Q25 - 1.5*dQ
A_oben  = Q75 + 1.5*dQ


%%
%**************************************************************************
% DARSTTELLUNGEN / PLOTS
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
% zu viele Datenpunkte --> Aufteilung in Klassen
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


%**************************************************************************
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

%**************************************************************************
%%
% STATISTISCHE TESTS - NULLHYPOTHESE
% (binomialverteilung - zwei Möglichkeiten - 6en Würfeln oder nicht)

% Binomialverteilung aufstellen mit Wahrscheinlichkeit p der H0. 
% Wahrscheinlichkeit auslesen, der tatsächlich eingetroffenen n. 
% wenn diese p < alpha, dann ablehnen. Beidseitiger Test, p < alpha/2
% (mit EXCEL)

% z.B.
% 6en Würfeln / 20 Versuche / 7 richtige
% H0: p = 1/6
% H1: p > 1/6   Einseitiger Test
% Signifikanzniveau alpha = 0.5%
% Binomialverteilung(n=20, p=1/6) --> x=7 --> p = 0.0259
% p = 0.0259 < alpha = 0.05  --> H0 ablehnen


%**************************************************************************
%%
% KORRELATION
% TEST VON ERWARTUNGSWERTEN
% (4 Möglichkeiten)

% STUDENT-T TEST
% Gegeben seien die Messreihen aus NORMalverteilten Grundgesamtheiten.

%************************************
% 1. EINE Stichprobe / EIN Erwartungswert
% H0: mu = mu0
X = [ 5 -5  7  4  15 -7  5  10  18  16 ];
mu = 0;
% Mittelwert Standard-Abweichung Schätzen
xbar = mean(X)
sx   = std(X)
% Berechne Testgrösse
Nx = length(X)
ttest = (xbar-mu)/sx*sqrt(Nx)
% bestimme (kritische) Annahmegrenzen
% Signifikanzniveau alpha = 5% --> in 5% der Fälle dürfen wir uns irren
alpha = 0.05;
% +- t(N-1; 1-a/2)
p = 1-alpha/2;
tcrit = tinv(p, Nx-1)
% Statistischer Schluss
% tcrit < ttest --> mu ist zu Unwahrscheinlich
if(abs(ttest)>=tcrit)
    disp("H0 verwerfen / Signigikante Abweichung")
else
    disp("H0 annehmen / Abweichung ist nicht signifikant")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))

%************************************
% 2. ZWEI Erwartungswerte, gleiche Varianz
% H0: sigma^2_x=sigma^2_y
X = [0, 1, 3, 4, 5, 6, 7];
Y = [36, 21, 24, 16, 13, 10, 6];
alpha = 0.001;
% Mittelwert Standard-Abweichung Schätzen
xbar = mean(X)
sx = std(X);
ybar = mean(Y)
sy = std(Y);
% Berechne Testgrösse
Nx = length(X);
Ny = length(Y);
ssq = ((Nx-1)*sx^2 + (Ny-1)*sy^2)/(Nx+Ny-2);
ttest = (xbar-ybar)/sqrt(ssq)*sqrt(Nx*Ny/(Nx+Ny))
% bestimme Annahmegrenzen
p = 1-alpha/2;
n = Nx+Ny-2;
tcrit = tinv(p, n)
% Statistischer Schluss
if(abs(ttest)>=tcrit)
    disp("H0 verwerfen / Signigikante Abweichung")
else
    disp("H0 annehmen / Abweichung ist nicht signifikant")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))

%************************************
% 3. ZWEI Erwartungswerte, ungleiche Varianz
% H0: VERSCHIEDENE SIGMA^2
X=[0.745 0.824 0.804 0.863 0.873 0.814 0.804 0.794 0.804 0.7453];
Y=[0.745 0.686 1.049 1.059 0.873 0.834 0.735 0.971 0.932 0.932 0.843 0.87];
% Mittelwert Standard-Abweichung Schätzen
alpha = 0.01;
xbar = mean(X)
sx = std(X);
ybar = mean(Y)
sy = std(Y);
% Berechne Testgrösse
Nx = length(X);
Ny = length(Y);
ssq = sx^2/Nx + sy^2/Ny;
ttest = (xbar-ybar)/sqrt(ssq)
% bestimme Annahmegrenzen 
c = (sx^2/Nx)/(sx^2/Nx + sy^2/Ny)
n = floor( 1/(c^2/(Nx-1) + (1-c)^2/(Ny-1)) )
p = 1-alpha/2;
tcrit = tinv(p, n)
% Statistischer Schluss
if(abs(ttest)>=tcrit)
    disp("H0 verwerfen / Signigikante Abweichung")
else
    disp("H0 annehmen / Abweichung ist nicht signifikant")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))

%************************************
% 4. ZWEI Erwartungswerte
% H0: mu1 = mu2 (VERBUNDENE STICHPROBE)
% verschiedene Messmethoden der gleichen Werte -> verbunden
% (vgl. Voltmeter von Alibaba vs. Keithley Voltmeter)
X=[100.5 102.4 104.3 101.5 98.4];
Y=[ 98.2  99.1 102.4 101.1 96.2];
d = X-Y;
alpha = 0.01;
mu = 0;
% Mittelwert Standard-Abweichung Schätzen
xbar = mean(d);
sx = std(d);
% Berechne Testgrösse
Nx = length(X)
ttest = (xbar-mu)/sx*sqrt(Nx)
% bestimme Annahmegrenzen 
p = 1-alpha/2;
tcrit = tinv(p, Nx-1)
% Statistischer Schluss
if(abs(ttest)>=tcrit)
    disp("H0 verwerfen / Signigikante Abweichung")
else
    disp("H0 annehmen / Abweichung ist nicht signifikant")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))
% Die Nullhypothese wird angenommen, die Differenz ist 0
% Die Mittelwerte sind gleich

%**************************************************************************
% KOVARIANZ & KORRELATION
% Korrelation: -1 < r_xy < 1
x = [0 1 3 4 5 6 7];
y = [36 21 24 16 13 10 6];
covv = cov(x, y) % Kovarianz
sxx = covv(1); % Varianz von x
sxy = covv(2);
syx = covv(3);
syy = covv(4); % Varianz von y
% ans =
%    [ std(x)^2,  sxy      ]  (sxy = Kovarianz)
%    [ syx     ,  std(y)^2 ]  (sxx = sx^2)

rcoeff = corrcoef(x,y);
rxy = rcoeff(2)
% ans = 
%   [?    rxy]
%   [rxy    ?]

x = [0 1 3 4 5 6 7];
y = [36 21 24 16 13 10 6];
rcoeff = corrcoef(x,y);
rxy = rcoeff(2)
n = length(x);
% die Korrelation ist signifikant, falls die Testgrösse
ttest = rxy*sqrt(n-2)/sqrt(1-(rxy^2))
% im Betrag grösser ist als die kritische Grösse
alpha = 0.001;
tcrit = tinv(1-alpha/2, n-2)
if(abs(ttest)>=tcrit)
    disp("Korrelation ist signifikant")
else
    disp("Korrelation ist NICHT signifikant")
end
disp(strcat("Irrtumswahrscheinlichkeit: ", num2str(alpha*100), "%"))




%**************************************************************************
% REGRESSION
%%
clear all; clc;
y = [1,2,3,4,5,6,7,8,9,10];
x = [2,2,2,4,4,6,6,6,10,10];

% REGRESSIONSGERADE der Form:
%  y = m*x + q
% (y = a*x + b)

% (1) mit linearem Gleichungssystem
X1 = [ones(length(x),1)  x'];
lsg = X1\y';
m = lsg(2);
q = lsg(1);

% (2) mit Polyfit
P = polyfit(x,y,1);
m = P(1);
q = P(2);

% (3) mit Kovarianz
covv = cov(x,y);
sxy = covv(2);
sxx = covv(1);
m = sxy/sxx
q = mean(y)-m*mean(x)

% Plot
yr = m.*x + q;
plot(x,y,'o')
hold on
plot(x,yr,'--r')

%%
% Varianzen der Regressionsgeraden
n = length(x);
rcoeff = corrcoef(x,y);
r = rcoeff(2); % rxy

sm2 = (1-r^2)*syy/(n-2)/sxx % Varianz von m (oder a)
sq2 = ((n-1)*(sxx)+n*mean(x)^2 )/n*sm2 % Varianz von q (oder b)
% Standardabweichungen:
sm = sqrt(sm2)
sq = sqrt(sq2)

% KONFIDENZINTERVALLE
alpha = 0.1;
quant = tinv(1-alpha/2, n-1 );
me = [m-sm*quant/sqrt(n), m+sm*quant/sqrt(n)]
qe = [q-sq*quant/sqrt(n), q+sq*quant/sqrt(n)]

% (?) Standardfehler der Regressionsgerade ???
sa = std(y)*sqrt(1/sum( (x-mean(x)).^2 ))







