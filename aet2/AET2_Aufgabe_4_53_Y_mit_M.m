%******************************************************************************
% \details     : AET2 Aufgabe 4-53
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_53.m
% \date        : 16.04.2018
% \version     : 1.0
%******************************************************************************
% Y-STERNSCHALTUNG MIT MITTELPUNKTLEITER

clear all; clc

% U1m_ = 230 * exp(j*0);
% U2m_ = abs(U1m_) * exp(j* (angle(U1m_) + deg2rad(-120)));
% U3m_ = abs(U1m_) * exp(j* (angle(U1m_) + deg2rad(120)));

U1m_ = 230*exp(j*(-2*pi/3*0));
U2m_ = 230*exp(j*(-2*pi/3*1));
U3m_ = 230*exp(j*(-2*pi/3*2));

% compass(U1m_); hold on
% compass(U2m_);
% compass(U3m_);

Z1_ = (2.77 + j*0);    % 
Z2_ = (1.51+ j*1.46);  % 
Z3_ = (4.00 - j*1.83); % 
Y1_ = 1/Z1_;
Y2_ = 1/Z2_;
Y3_ = 1/Z3_;

I1_ = U1m_ / Z1_
I2_ = U2m_ / Z2_
I3_ = U3m_ / Z3_

IM_ = I1_ + I2_ + I3_;

I1=strcat(num2str(abs(I1_)), "A /_ ", num2str(rad2deg(angle(I1_))), "°")
I2=strcat(num2str(abs(I2_)), "A /_ ", num2str(rad2deg(angle(I2_))), "°")
I3=strcat(num2str(abs(I3_)), "A /_ ", num2str(rad2deg(angle(I3_))), "°")
IM=strcat(num2str(abs(IM_)), "A /_ ", num2str(rad2deg(angle(IM_))), "°")

S_ = U1m_*I1_' + U2m_*I2_' + U3m_*I3_'





