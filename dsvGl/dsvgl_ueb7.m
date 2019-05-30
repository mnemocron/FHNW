%**************************************************************************
% \details     : digitale Signalverarbeitung - U7
% \autor       : Simon Burkhardt
% \file        : dsvgl_ueb7.m
% \date        : 08.04.2019
% \version     : 1.0
%**************************************************************************

%%
% Aufgabe 1
% Wir betrachten zunächst das Signal y(t) = cos(2*?*f0*t) mit f0 = 4. 
% Dieses wird mit TS = 1/N abgetastet, wobei wir vorläufig N = 32 wählen. 

% a)
% Bestimmen Sie die Koeffizienten ci der komplexen Fourierreihe von y(t). 
% Tipp: Überlegen, nicht rechnen.

% cos => gerade Funktion
% c_{1} = 1/2
% c_{-1} = 1/2

% b) Erstellen Sie in MATLAB einen Vektor y, der N = 32 Abtastwerte von y(t) 
% enthält. Verwenden Sie den Befehl stem() um diese Abtastwerte zu plotten.
clear all; close all; clc; format shorteng;

N = 32;
f0 = 4;
Ts = 1/N;

k = 0:N-1; % Abtastwerte
t = k.*Ts; % Abtastzeitpunkte

y = cos(2*pi*f0*t);
stem(k,y);

%%
% c) Berechnen Sie Y = fft(y) und plotten Sie den Betrag von Y mit stem(). 
% Entspricht das Ergebnis Ihren Erwartungen? Wie ist der Zusammenhang 
% zwischen den Werten von Y und den komplexen Fourierkoeffizienten? 

Y = fft(y);
stem(k, abs(Y));

% Peak bei f = 4, Höhe 16
% Korrektur der Höhe * 1/N --> 1/2, entspricht c_{1}
% Peak bei f = 28, Höhe 16
% Korrektur --> entspricht c_{-1}
% ist die negative Hälfte vom Spektrun, die jetzt bei 32-4 = 28 auftaucht

%%
% d) Wiederholen Sie b) bis c) mit N = 64.
clear all; close all; clc;

N = 64;
f0 = 4;
Ts = 1/N;

k = 0:N-1; % Abtastwerte
t = k.*Ts; % Abtastzeitpunkte

y = cos(2*pi*f0*t);
stem(k,y);

%%
Y = fft(y);
stem(k, abs(Y));
% nun ist die Frequenzauflösung auch 64

%%
% e) Addieren Sie die Abtastewerte eines zweiten Signals 
% y2(t) = ½*cos(2*?*6*t) zu y hinzu. Bestimmen Sie wiederum die diskrete 
% Fouriertransformation und stellen Sie diese graphisch dar. 
clear all; close all; clc;
N = 64;
f0 = 4;
Ts = 1/N;

k = 0:N-1;
t = k.*Ts;

y1 = cos(2*pi*f0*t);
y2 = 0.5 * cos(2*pi*6*t);
y = y1+y2;
subplot(1,2,1);
stem(k,y);

Y = fft(y);
subplot(1,2,2);
stem(abs(Y));

%%

% f) Wiederholen Sie b) bis d) mit f0 = 4.5. Entspricht das Ergebnis Ihren Erwartungen? Falls 
% nein, woran liegt das?
clear all; close all; clc;
N = 64;
f0 = 4.5;
Ts = 1/N;

k = 0:N-1;
t = k.*Ts;

y1 = cos(2*pi*f0*t);
y2 = 0.5 * cos(2*pi*6*t);
y = y1+y2;
subplot(1,2,1);
stem(k,y);

Y = fft(y);
subplot(1,2,2);
stem(abs(Y));
% von y1 haben nicht mehr eine ganze Anzahl Perioden im Zeitfenster platz
% die FFT geht aber davon aus, dass das Signal Periodisch fortgesetzt wird

% g) Unter welchen Bedingungen entsprechen die Werte der diskreten
% Fouriertransformation eines bandbegrenzten Signals gerade den komplexen 
% Fourierkoeffizienten? 

% wenn:
% - das Signal periodisch ist
% - das Zeitfenster des zu Analysierenden Signals genau eine ganze Anzahl
% Perioden festhält

%%
%**************************************************************************
% Aufgabe 2)
% Wir betrachten nun das Signal y(t) = ½cos(2*?*f0*t))½ mit f0 = 4. 
% Es handelt sich dabei um ein nicht bandbegrenztes Signal. 
%%
% a) Zeichnen Sie y(t) für 0 ? t < 1.
clear all; close all; clc;
f0 = 4;
t = linspace(0,1,1e3);

y = abs(cos(2*pi*f0*t));
plot(t,y); hold on

%%
% b) Bestimmen Sie die Koeffizienten ci der komplexen Fourierreihe von y(t). 
% Beachten Sie, dass y(t) ein periodisches Signal mit der 
% Grundfrequenz 2*f0 = 8 ist.




%%
% c) Das Signal y(t) wird nun mit TS = 1/N abgetastet. Erstellen Sie in
% MATLAB einen Vektor y, der N = 64 Abtastwerte von y(t) enthält. 
% Verwenden Sie den Befehl stem() um diese Abtastwerte zu plotten. 
clear all; close all; clc;
f0 = 4;
N = 64;
Ts = 1/N;
k = 0:N-1;
t = k.*Ts;
y = abs(cos(2*pi*f0*t));
stem(t, y);


%%
% d) Berechnen Sie Y = fft(y) und plotten Sie den Betrag von Y mit stem(). 
% Vergleichen Sie die Werte von Y mit den komplexen Fourierkoeffizienten.
% Was fällt Ihnen auf? Woran liegt das?
Y = fft(y);
figure(2);
stem(abs(Y)/N);

Y_64 = abs(Y)/N;
% Die Höhe der Frequenzen stimmt nicht genau
% Weil eine Überlagerung des gespiegelten Spektrums geschieht

%%
% e) Wiederholen Sie c) und d) mit N = 1024. Was ergibt nun der Vergleich 
% der Werte von Y mit den komplexen Fourierkoeffizienten? 
close all; clc;
f0 = 4;
t = linspace(0,1,1e3);

y = abs(cos(2*pi*f0*t));
plot(t,y); hold on

N = 1024;
Ts = 1/N;
k = 0:N-1;
t = k.*Ts;
y = abs(cos(2*pi*f0*t));
subplot(2,1,1);
stem(t, y);

Y = fft(y);
subplot(2,1,2);
stem(abs(Y)/N);

%%
% Vergleich
figure(2);
Y_1024 = abs(Y(1:64))/N;
stem(Y_64); hold on
stem(Y_1024);
% Die Koeffizienten mit 1024 Abtastwerten stimmen genauer, da das
% gespiegelte Spektrum kleinere Koeffizienten hat

% f) Können die komplexen Fourierkoeffizienten eines nicht bandbegrenzten 
% Signals mit Hilfe der diskreten Fouriertransformation exakt bestimmt 
% werden? Unter welchen Bedingung können die Fourierkoeffizienten wenigstens 
% mit guter Genauigkeit angenähert werden? 

% Nein
% mit genügend hoher Abtastrate
% evtl. unter Zuhilfenahme von Fensterfunktionen

%%
%**************************************************************************
% Aufgabe 3)
% Man könnte auf die Idee kommen, die diskrete Fouriertransformation auch 
% zur Berechung von Faltungssummen einzusetzen, schliesslich gilt
% Y(z) = H(z)*X(z)
%%
% a) Definieren Sie in MATLAB zwei Vektoren x und h der Länge N = 32, 
% bei denen jeweils die ersten beiden Werte gleich eins, 
% die restlichen Werte gleich null sind.
clear all; close all; clc; format shorteng;

x = zeros(1,32);
x(1) = 1;
x(2) = 1;
h = zeros(1,32);
h(1) = 1;
h(2) = 1;

%%
% b) Berechnen und plotten Sie die Faltungssumme 
% mit Hilfe des Befehls conv().
y = conv(x,h);
stem(y);

%%
% c) Berechnen Sie die diskrete Fouriertransformationen X und H 
% sowie deren Produkt Y. 
% Tipp: Verwenden Sie die elementweise Multiplikation .*  

X = fft(x);
H = fft(h);
Y = H.*X;

%%
% d) Transformieren Sie Y zurück und betrachten Sie das Resultat. 
y = ifft(Y);
stem(y);

%%
% e) Wiederholen Sie b) bis d), aber verwenden Sie für x einen Vektor, 
% der aus lauter Einsen besteht. Entspricht das Resultat Ihren Erwartungen? 
clear all; close all; clc; format shorteng;

x = ones(1,32);
h = zeros(1,32);
h(1) = 1;
h(2) = 1;

y = conv(x,h);
stem(y);

%%
X = fft(x);
H = fft(h);
Y = H.*X;

y = ifft(Y);
stem(y);

% f) Unter welchen Voraussetzungen kann die diskrete Fouriertransformation
% zur Berechnung der Faltungssumme verwendet werden? 






