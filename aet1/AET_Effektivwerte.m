clc; clear;

% rms() udn mean() funktioniert nur mit Bereichen 
% von 0 bis ganzzahlige vielfache von pi, 
% solange innerhalb der Funktionen auch nur 
% ganzzahlige Vielfache von pi vorkommen und 
% diese die gleiche oder die vielfache Frequenz besitzen.

% Anders Ausgedrückt: rms() und mean() funktionieren nur
% wenn die Dauer des Signals eiem ganzzahligen Vielfachen der
% Periodendauer entspricht.

t=linspace(0, pi, 1e7);        % t von 0 bis pi
u=-6-5*cos(4*t)+3*sin(4*t+1);  % Spannungsform
rms_pi = rms(u)
mean_pi = mean(u)



% A + (B-A)*|cos(wt)|
x=linspace(0, 4*pi, 1e3);
u=4+(10-4)*abs(cos(x));
plot(x, u)
mean(u);            % 7.8219
mean(u.^2);         % 64.5932
sqrt(mean(u.^2))    % 8.037



ud=10;
N=1e3;
T=pi;
x=linspace(0,T,N);
y=abs(ud*sin(x));
A=T/N*sum(y)       % Fläche des sinus
A2=T/N*sum(y.^2)   % 
A22 = sqrt(sum(y.^2/N)) % RMS
% A3=sqrt(A2/pi)      % RMS

clc; clear;
N = 200;
Ip = 2; T = 2e-3; R = 47;
t = linspace(0, T, N);
i = Ip / T*t;
plot(t, i);

% Leistungs"integral" :
p = i.^2*R;
plot(t, p);
A = sum(p)*T/N;
P = A/T;



%%%%%%%%
clc; clear;
Up=3;           % Spitzenwert (Upeak)
T=pi;           % Periodendauer
N=100000;       % Anzahl Rechenpunkte
t=linspace(0, T, N);
u=Up*sin(t);
%plot(t, u);

% Mittelwert
Area=sum(u.*(T/N))  % Fläche bei T=pi/Up=1 muss 2 sein
Um=Area/T

% Effektivwert nach RMS Prinzip
square=sum(u.^2 * T/N)
mean=square/T
root=sqrt(mean)     % Ueff muss gleich sein wie Up/sqrt(2)






