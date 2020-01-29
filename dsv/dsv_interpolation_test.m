%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : 
% \date        : 01.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

fs = 44100;
Ts = 1/fs;

f1 = 1000; T1 = 1/f1;
f2 =  500; T2 = 1/f2;

% originales Zeitsignal mit maximaler Frequenz < fs/2
t = linspace(0, 4*T1, 4*T1/Ts);
x = 0.5*sin(2*pi*f1*t) + 0.3*sin(2*pi*f2*t);
% x = 0.5*sin(2*pi*f1*t);
% plot(t,x);

X = abs(fft(x));
% stem(X)

%% downsampling ohne LP-filtering (weil ja oben f1 < fs/2)
L = 2;
fsl = fs/L; Tsl = Ts*L;
xl = x(1:L:end);
tl = t(1:L:end);
plot(t, x); hold on;
plot(tl, xl);

%% Spektrum von downsampled signal, periodisch wiederholt
Xl = abs(fft(xl));
stem(X); hold on;
stem([Xl, Xl]);


%% upsampling
M = L;
fsm = M*fsl; Tsm = Tsl/M;
xu = reshape([xl; zeros(size(xl))], [], 1);  % here should use M as argument
plot(t, x); hold on;
plot(t, xu);

%% Spektrum des upsampled Signal, ohne LP-filtering
Xu = abs(fft(xu));
stem(X); hold on;
stem(Xu);

%% LP Filter des Upsampled Signals
Fu = fir1(48, fsl/fsm);
Fu = designfilt('lowpassfir', 'FilterOrder', 47, 'PassbandFrequency', fsl/fsm-0.05, 'StopbandFrequency', fsl/fsm+0.05);
y = 2*filter(Fu, xu);
plot(t, x); hold on;
plot(t, y);






