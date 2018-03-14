% Linearer Array, Diagramm
%

clear all; clc;

% d zu Lambda
d_L=0.5;

% Anzahl Elemente
n=8;

anzp=300;
psi_d=linspace(0,180,anzp);
psi_r=deg2rad(psi_d);

% Nebenkeulenunterdrückung mit folgender Funktion:
% b ist der Dämfungsgrad ~
b = 0;    % 1 = keine Dämpfung / 0 = maximale Nebenkeulenunterdrückung
amp = @(x) (b+1)/(2)+ (b-1)/(2)*cos(2*pi*x);

% plot(linspace(1,n,n), amp(linspace(1,n,n)));

%%
% mit komplexen Zeigern
s=0;
for k=1:n
    
    s=s+amp((k-1)/n)*exp(-j*d_L*2*pi*cos(psi_r)*(k-1));    
    
end;

% Normierung
sn=abs(s)/max(abs(s));

sndb=20*log10(sn);
plot(psi_d,sndb), grid on;
axis([0 180 -40 0]);
title('Strahlungsdiagramm eines linearen Arrays');

%% 
% mit Cosinus (tut aber nicht funktionieren, tut das...)
s=0;
for k=1:n
    
    %s=s+ ((cos(d_L*2*pi*cos(psi_r)*(k-1))).^2 + (sin(d_L*2*pi*cos(psi_r)*(k-1))).^2);    
    s=s+cos(d_L*2*pi*cos(psi_r)*(k-1));
end;

% Normierung
sn=abs(s)/max(abs(s));
sn=s/max(abs(s));

sndb=20*log10(sn);
hold on
plot(psi_d,sndb)
axis([0 180 -50 0]);

