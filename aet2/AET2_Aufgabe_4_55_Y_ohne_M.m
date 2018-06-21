%******************************************************************************
% \details     : AET2 Aufgabe 4-55
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_55.m
% \date        : 21.04.2018
% \version     : 1.0
%******************************************************************************
% Y-STERNSCHALTUNG OHNE MITTELPUNKTSLEITER
%******************************************************************************

clear all; clc

U12_ = 400*exp(j*(-2*pi/3*0));
U23_ = 400*exp(j*(-2*pi/3*1));
U31_ = 400*exp(j*(-2*pi/3*2));

Z1_ = 10 + j*17;
Z2_ = j*40;
Z3_ = 8.66 - j*5;

Y1_ = 1/Z1_;
Y2_ = 1/Z2_;
Y3_ = 1/Z3_;

Z_ = stern2dreieck(Z1_, Z2_, Z3_, false);
Z12_ = Z_.Ra;
Z23_ = Z_.Rb;
Z31_ = Z_.Rc;

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


%
U1ms_ = I1_ * Z1_;
U2ms_ = I2_ * Z2_;
U3ms_ = I3_ * Z3_;
U1ms=strcat(num2str(abs(U1ms_)), "V /_ ", num2str(rad2deg(angle(U1ms_))), "°")
U2ms=strcat(num2str(abs(U2ms_)), "V /_ ", num2str(rad2deg(angle(U2ms_))), "°")
U3ms=strcat(num2str(abs(U3ms_)), "V /_ ", num2str(rad2deg(angle(U3ms_))), "°")

Umms_ = (U1ms_ + U2ms_ + U3ms_ ) /3;
%Umms_ = - (U1m_*Y1_ + U2m_*Y2_ + U3m_*Y3_) / (Y1_+Y2_+Y3_)
Umms=strcat(num2str(abs(Umms_)), "V /_ ", num2str(rad2deg(angle(Umms_))), "°")

U1m_ = U1ms_ - Umms_;
U2m_ = U2ms_ - Umms_;
U3m_ = U3ms_ - Umms_;

U1m=strcat(num2str(abs(U1m_)), "V /_ ", num2str(rad2deg(angle(U1m_))), "°")
U2m=strcat(num2str(abs(U2m_)), "V /_ ", num2str(rad2deg(angle(U2m_))), "°")
U3m=strcat(num2str(abs(U3m_)), "V /_ ", num2str(rad2deg(angle(U3m_))), "°")








