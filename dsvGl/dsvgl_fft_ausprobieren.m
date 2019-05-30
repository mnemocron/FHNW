%******************************************************************************
% \details     : digitale Signalverarbeitung - FFT Ausprobieren
% \autor       : Simon Burkhardt
% \file        : dsvgl_fft_ausprobieren.m
% \date        : 08.04.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;

N = 32;
f0 = 4/N;

Ts = 1;
fs = 1/Ts;
k = 0:N-1;
t = k.*Ts;

x = sin(2*pi*f0*t);
stem(k,x);

%%
X = fft(x);
f = k*fs/N;
stem(f, abs(X));


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

