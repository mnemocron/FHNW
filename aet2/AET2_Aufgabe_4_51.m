%******************************************************************************
% \details     : AET2 Aufgabe 4-51
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_51.m
% \date        : 16.04.2018
% \version     : 1.0
%******************************************************************************
% DREIECKSCHALTUNG symmetrische Last, U12 gegeben

clear all; clc

U12_ = 400 * exp(j*0);
U23_ = abs(U12_) * exp(j*(angle(U12_)+deg2rad(-120)));
U31_ = abs(U12_) * exp(j*(angle(U12_)+deg2rad(120)));

rad2deg(angle(U23_))
rad2deg(angle(U31_))

% U1m_ = abs(U12_)/cos(deg2rad(30)) * exp(j* deg2rad(-30));
% U2m_ = abs(U1m_) * exp(j* deg2rad(180+30));
% U3m_ = abs(U1m_) * exp(j* deg2rad(90));
% 
% U1m=strcat(num2str(abs(U1m_)), "V /_ ", num2str(rad2deg(angle(U1m_))), "°")
% U2m=strcat(num2str(abs(U2m_)), "V /_ ", num2str(rad2deg(angle(U2m_))), "°")
% U3m=strcat(num2str(abs(U3m_)), "V /_ ", num2str(rad2deg(angle(U3m_))), "°")
% 
% compass(U1m_); hold on
% compass(U2m_); 
% compass(U3m_);

%%

Z_ = 92+j*77;

% I1m_ = U1m_/Z_;
% I2m_ = U2m_/Z_;
% I3m_ = U3m_/Z_;
% 
% I1m=strcat(num2str(abs(I1m_)), "A /_ ", num2str(rad2deg(angle(I1m_))), "°")
% I2m=strcat(num2str(abs(I2m_)), "A /_ ", num2str(rad2deg(angle(I2m_))), "°")
% I3m=strcat(num2str(abs(I3m_)), "A /_ ", num2str(rad2deg(angle(I3m_))), "°")
% 
% figure(2)
% compass(I1m_); hold on
% compass(I2m_);
% compass(I3m_);

%%

I12_ = U12_/Z_;
I23_ = U23_/Z_;
I31_ = U31_/Z_;

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

figure(3)
compass(I12_); hold on
compass(I23_);
compass(I31_);

S_ = U12_*I12_' + U23_*I23_' + U31_*I31_'


