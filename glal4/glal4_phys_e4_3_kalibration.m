%**************************************************************************
% \details     : Kalibrationskennlinie für E4.3
% \autor       : Simon Burkhardt
% \file        : glal4_phys_e4_3_kalibration.m
% \date        : 19.04.2019
% \version     : 1.0
%**************************************************************************

%%
% Kallibration
% Fitkurve mit Messdaten
clear all; clc; format shorteng;

I = 0.6; % (Konstante)
N = 474; % (Konstante)
R = 0.014; % (Konstante)
len = 0.068; % (Konstante)
mu0 = 1.256637061436e-06; % (Konstante)
% z0 = -3.4840886454754e-02 +/- 1.2919571173011e-04
z0 = -3.4840886454754e-02;

B = @(x) (mu0*N*I)/len*1/2*(((len/2+(x-z0))/sqrt((len/2+(x-z0))^2+R^2))+((len/2-(x-z0))/sqrt((len/2-(x-z0))^2+R^2)));

z = linspace(-0.08, 0.04, 1e3);
Bz = z;
for k=1:length(z)
    Bz(k) = B(z(k));
end

plot(z, Bz)

