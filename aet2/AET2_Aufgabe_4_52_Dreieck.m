%******************************************************************************
% \details     : AET2 Aufgabe 4-52
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_52.m
% \date        : 16.04.2018
% \version     : 1.0
%******************************************************************************
% DREIECKSCHALTUNG-LAST, U12 gegeben

clear all; clc

U12_ = 400 * exp(j*0);
U23_ = abs(U12_) * exp(j*(angle(U12_)+deg2rad(-120)));
U31_ = abs(U12_) * exp(j*(angle(U12_)+deg2rad(120)));

Z12_ = (10 + j*0);   % 
Z23_ = (8.66 + j*5); % 
Z31_ = (13 - j*7.5); % 

I12_ = U12_/Z12_;
I23_ = U23_/Z23_;
I31_ = U31_/Z31_;

I12=strcat(num2str(abs(I12_)), "A /_ ", num2str(rad2deg(angle(I12_))), "°")
I23=strcat(num2str(abs(I23_)), "A /_ ", num2str(rad2deg(angle(I23_))), "°")
I31=strcat(num2str(abs(I31_)), "A /_ ", num2str(rad2deg(angle(I31_))), "°")

% Knotensatz !!!!!
I1_ = I12_ - I31_;
I2_ = I23_ - I12_;
I3_ = I31_ - I23_;

I1=strcat(num2str(abs(I1_)), "A /_ ", num2str(rad2deg(angle(I1_))), "°")
I2=strcat(num2str(abs(I2_)), "A /_ ", num2str(rad2deg(angle(I2_))), "°")
I3=strcat(num2str(abs(I3_)), "A /_ ", num2str(rad2deg(angle(I3_))), "°")

%% 

% jede Impedanz

S12_ = U12_*I12_'
P12 = real(S12_);
Q12 = imag(S12_);
% S12=strcat(num2str(abs(S12_)), "VA /_ ", num2str(rad2deg(angle(S12_))), "°")
% P12_=strcat(num2str(abs(P12)), "W /_ ", num2str(rad2deg(angle(P12))), "°")
% Q12_=strcat(num2str(abs(Q12)), "VAr /_ ", num2str(rad2deg(angle(Q12))), "°")

S23_ = U23_*I23_'
P23 = real(S23_);
Q23 = imag(S23_);
% S23=strcat(num2str(abs(S23_)), "VA /_ ", num2str(rad2deg(angle(S23_))), "°")
% P23_=strcat(num2str(abs(P23)), "W /_ ", num2str(rad2deg(angle(P23))), "°")
% Q23_=strcat(num2str(abs(Q23)), "VAr /_ ", num2str(rad2deg(angle(Q23))), "°")

S31_ = U31_*I31_'
P31 = real(S31_);
Q31 = imag(S31_);
% S31=strcat(num2str(abs(S31_)), "VA /_ ", num2str(rad2deg(angle(S31_))), "°")
% P31_=strcat(num2str(abs(P31)), "W /_ ", num2str(rad2deg(angle(P31))), "°")
% Q31_=strcat(num2str(abs(Q31)), "VAr /_ ", num2str(rad2deg(angle(Q31))), "°")

Stot_ = S12_ + S23_ + S31_








