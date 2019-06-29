%******************************************************************************
% \details     : digitale Signalverarbeitung - FFT Ausprobieren
% \autor       : Simon Burkhardt
% \file        : dsvgl_fft_ausprobieren.m
% \date        : 08.04.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;

% N = 32;     % Anzahl Abtastwerte t --> Anzahl Abtastwerte f
% f0 = 4/N;   % Frequenz des Signals = 0.125 --> 8 Abtastwerte pro Periode

N = 32;
f0 = 0.125;

Ts = 1;     % 
fs = 1/Ts;  % = 1
k = 0:N-1;  
t = k.*Ts;

x = sin(2*pi*f0*t);
subplot(2,1,1);
stem(k,x);

X = fft(x);
f = k*fs/N;
subplot(2,1,2);
stem(f, abs(X));

% die Koeffizienten X der FFT sind in N Teile von 0Hz - fs eingeteilt
% bei fs = 1Hz und N = 32 ist die Frequenzauflösung 1/32
% ist f0 bei 0.125Hz * 32 = 4
%       0 1 2 3 4               * fs/N
% X = [ 0 0 0 0 1 0 0 0 ... 0 ]

%%
clear all; close all; clc; format shorteng;

N = 32;
f0 = 3.25/N;

Ts = 1;
fs = 1/Ts;
k = 0:N-1;
t = k.*Ts;

x = sin(2*pi*f0*t);
stem(k,x);

X = fft(x);
f = k*fs/N;
figure(2);
stem(f, abs(X));


%%
clear all; close all; clc; format shorteng;

N = 32;
f0 = 3.25/N;
w = hamming(N)';

Ts = 1;
fs = 1/Ts;
k = 0:N-1;
t = k.*Ts;

x = sin(2*pi*f0*t);
stem(k,x.*w);

X = fft(x.*w);
f = k*fs/N;
figure(2);
stem(f, abs(X));

