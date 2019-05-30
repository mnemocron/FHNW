%**************************************************************************
% \details     : digitale Signalverarbeitung - FIR Ausprobieren
% \autor       : Simon Burkhardt
% \file        : dsvgl_fir_ausporbieren.m
% \date        : 15.04.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;

fs = 8000;
Ts = 1/fs;
k = -200:200;
t = k*Ts;
% t = k*Ts + eps;
fg = 1000; % < 8000/2 (nyquist)
h = sin(2*pi*fg*t)./(pi*t);
h(201) = 2*fg;

h = h/(2*fg);  % Skalierungsfaktor

stem(h)

%%
freqz(h);

%%
fvtool(h);


%%
clear all; close all; clc;
format shorteng;

fs = 8000;
Ts = 1/fs;
k = -200:200;
t = k*Ts;
% t = k*Ts + eps;
fg = 1000; % < 8000/2 (nyquist)
h = sin(2*pi*fg*t)./(pi*t);
h(201) = 2*fg;

w = hamming(401);
hw = h .* w';

h = Ts*h;  % Skalierungsfaktor

fvtool(hw);



%%

clear all; clc; format shorteng;

L = 16;
H = [1 1 1 0 0 0 0 0 0];
% H = [1 1 1 0.5 0 0 0 0 0];

n = 0:L/2;
phi = -(L-1)/L*pi*n;

H = H.*exp(j*phi)
m = 2:8;
H(L-m+2) = conj(H(m))
h = ifft(H);

stem(h)

%%
% Rezept, Vereinfacht
clear all; clc; format shorteng;

L = 15;
H = [1 1 1 0 0 0 0 0 0];

m = 2:8;
H(L-m+2) = conj(H(m))
h = ifft(H);

stem(h)







