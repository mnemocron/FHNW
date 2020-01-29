%******************************************************************************
% \details     : 
% \autor       : Simon Burkhardt
% \file        : dsv_Aufg_3.4.7.m
% \date        : 12.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;
Omeg = linspace(0, 2* pi);
z = exp(j*Omeg);


OMg = pi/6;
Om1 = pi/3;
alpha = sin((OMg-Om1)/2) / sin((OMg+Om1)/2)

zm1 = (z.^-1 - alpha) ./ (1 - alpha.*z.^-1);

Hlp1 = (0.0495.*(1+z.^-1).^2) ./ (1-1.28.*z.^-1+0.478.*z.^-2);
Hlp2 = (0.0495.*(1+zm1).^2) ./ (1-1.28.*zm1+0.478.*zm1.^2);



% Hlp = (0.0495.*(1+z.^-1).^2) ./ (1-1.28.*z.^-1+0.478.*z.^-2);
plot(Omeg, abs(Hlp1)); hold on;
plot(Omeg, abs(Hlp2)); grid on;


