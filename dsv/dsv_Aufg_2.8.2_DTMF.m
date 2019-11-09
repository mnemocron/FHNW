%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_2.8.2_DTMF.m
% \date        : 10.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

fs = 8000;
N = 1024;

y = DTMFGen("0", fs, N);

f = linspace(0, fs, N);
Y = fft(y);

stem(f(1:N/2), abs(Y(1:N/2)));
grid on

%%
Ya = abs(Y(1:N/2));
% [a,b] = max(Ya);
[val, ind] = sort(Ya);

f1_ind = ind(length(ind));
f2_ind = ind(length(ind)-1);

f1 = Ya(f1_ind);
f2 = Ya(f2_ind);

for n=1:10
    f1 = [f1, Ya(f1_ind + n), Ya(f1_ind - n)];
    f2 = [f2, Ya(f2_ind + n), Ya(f2_ind - n)];
end

rms(f1)
rms(f2)

%%
clear all; clc;
format shorteng;

fs = 44100;
N = fs * 0.15;
silence = zeros(1, round(fs * 0.15/2));

% test all symbols
sinp = '0123456789ABCD*#';

for k=1:length(sinp)
    y = DTMFGen(sinp(k), fs, N);
    sym = DTMFDec(y, fs, N)
    soundsc([silence, y], fs);
end




