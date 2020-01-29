%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_3.4.6.m
% \date        : 12.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

OMg = 0.2*pi;
Om1 = 2*pi/5;
Om2 = 3*pi/5;

alpha = cos( (Om2+Om1)/2 ) / cos( (Om2-Om1)/2 )
k = tan(OMg/2)/tan( (Om2-Om1)/2 )


%%
% c) Peak bei fs/4
clear all; clc; 

Omeg = linspace(0, 2* pi);

z = exp(j*Omeg);

H = (0.245.*(1-z.^-2))./(1+0.509.*z.^-2);


plot(Omeg, abs(H)); grid on

%%
% Pole-Zero Plot
clear all; clc; 

zer = [-1; 1];
pol = [-j*0.713; j*0.713];

zplane(zer, pol)
grid on
