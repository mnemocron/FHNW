%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_2.8.13_Rauschleistungsdichte.m
% \date        : 04.11.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

Q = 2^16;       % Abtastwerte
x = randn(1,Q); % randn = Gaussverteilt
fs = 2500;

% a)
N = 2^13;       % FFT Länge
D = N/2;        % Segment Overlap (50%)

% [] = rect window
% pwelch(x, D, [], N);

M = (Q-N)/D + 1; % Anzahl Segmente

w = ones(1, N); % rect window

Ew = sum(abs(w).^2)

Xm = zeros(1,N);

xw = 0;
for i=1:M
    a=(i-1)*D+1;
    b=(i-1)*D+N;
    xi = x(a:b);
    xiw = xi.*w;
    Xi = fft(xiw);
    Xm = Xm + abs(Xi).^2;
end

Sxx = 1/(M*Ew) * sum( abs( Xm ).^2 )

subplot(2,1,1)
% muss mit Ts Skaliert werden
% Energie des Fensters muss berücksichtigt werden (M*Ew)
plot( linspace(0,fs,N), 10*log10(abs(Xm /(fs*M*Ew))) );
grid on
title("Power Density Spectrum")
ylabel("Power/frequency (dB/Hz)")
xlabel("Frequency (Hz)")

% c)
subplot(2,1,2)
pwelch(x, rectwin(N), N/2, (0:N-1)*fs/N, fs)

%%
% d)
f1 = 20.6;
f2 = 23.8;
A1 = 128;
A2 = 0.128;

t = linspace(0, Q/fs, Q);

x = randn(1,Q) + A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t);
sxx = pwelch(x, rectwin(N), N/2, (0:N-1)*fs/N, fs);

% e)
L = 330;
plot(linspace(0, L*fs/N, L), 10*log10( abs( sxx(1:L) )) );
grid on
title("Power Density Spectrum (rectwin)")
ylabel("Power/frequency (dB/Hz)")
xlabel("Frequency (Hz)")

% f)
hold on
sxx = pwelch(x, hamming(N), N/2, (0:N-1)*fs/N, fs);
Ew = sum(abs( hamming(N) ).^2)
plot(linspace(0, L*fs/N, L), 10*log10( abs( sxx(1:L) )) );

sxx = pwelch(x, kaiser(N, 10), N/2, (0:N-1)*fs/N, fs);
Ew = sum(abs( kaiser(N, 10) ).^2)
plot(linspace(0, L*fs/N, L), 10*log10( abs( sxx(1:L) )) );

legend(["rectwin","hamming","kaiser (B=10)"])
% Frage:
% Stimmen die db/Hz ohne Skalierung mit Ew ?

% g) ...







