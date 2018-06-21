%******************************************************************************
% \details     : AET2 Aufgabe 4-56
% \autor       : Simon Burkhardt
% \file        : AET_Aufgabe_4_56.m
% \date        : 21.04.2018
% \version     : 1.0
%******************************************************************************
clear all; clc

Zi_ = 0.1+0.2*j;
Zux_ = 3 + j*4;
Zvy_ = 3 + j*4;
Zwz_ = 5 + j*8;

%% 
% a)
U12_ = 400*exp(j*(-2*pi/3*0));
U23_ = 400*exp(j*(-2*pi/3*1));
U31_ = 400*exp(j*(-2*pi/3*2));

ppcomp(U12_, "U12_", "V")
ppcomp(U23_, "U23_", "V")
ppcomp(U31_, "U31_", "V")

U1m_ = abs(U12_)/2/cos(deg2rad(30)) * cis(-30, "grad");
U2m_ = abs(U23_)/2/cos(deg2rad(30)) * cis(180 + 30, "grad");
U3m_ = abs(U31_)/2/cos(deg2rad(30)) * cis(90, "grad");

ppcomp(U1m_, "U1m_", "V")
ppcomp(U2m_, "U2m_", "V")
ppcomp(U3m_, "U3m_", "V")

%%
% d)
% Sternschaltung OHNE Mittelpunkt

"STERNSCHALTUNG ohne Mittelpunkt"

Zuxm_ = Zux_ + Zi_;
Zvym_ = Zvy_ + Zi_;
Zwzm_ = Zwz_ + Zi_;

Z_ = stern2dreieck(Zuxm_, Zvym_, Zwzm_, false);
Z12_ = Z_.Ra;
Z23_ = Z_.Rb;
Z31_ = Z_.Rc;

I12_ = U12_/Z12_;
I23_ = U23_/Z23_;
I31_ = U31_/Z31_;

ppcomp(I12_, "Iux_", "A")
ppcomp(I23_, "Ivy_", "A")
ppcomp(I31_, "Iwz_", "A")

% Knotensatz !!!!!
I1_ = I12_ - I31_;
I2_ = I23_ - I12_;
I3_ = I31_ - I23_;

ppcomp(I1_, "I1_", "A")
ppcomp(I2_, "I2_", "A")
ppcomp(I3_, "I3_", "A")

%%
% d)
% Dreiecksschaltung

"DREIECKSSCHALTUNG"

Z12_ = Zux_;
Z23_ = Zvy_;
Z31_ = Zwz_;

% umgeformt in Sternschaltung ohne Mittelpunktsleiter
Z_ = dreieck2stern(Zux_, Zvy_, Zwz_, true);
Z1m_ = Z_.Rb + Zi_;
Z2m_ = Z_.Ra + Zi_;
Z3m_ = Z_.Rc + Zi_;

Y1_ = 1/Z1m_;
Y2_ = 1/Z2m_;
Y3_ = 1/Z3m_;

Umms_ = - (U1m_*Y1_ + U2m_*Y2_ + U3m_*Y3_)/(Y1_+Y2_+Y3_);
ppcomp(Umms_, "Umm'", "V")
Umms_ = 46.9786*cis(36.7289, "deg");

U1ms_ = U1m_ + Umms_;
U2ms_ = U2m_ + Umms_;
U3ms_ = U3m_ + Umms_;
ppcomp(U1ms_, "U1m'", "V")
ppcomp(U2ms_, "U2m'", "V")
ppcomp(U3ms_, "U3m'", "V")

I1_ = U1ms_/Z1m_;
I2_ = U2ms_/Z2m_;
I3_ = U3ms_/Z3m_;
ppcomp(I1_, "I1_", "A")
ppcomp(I2_, "I2_", "A")
ppcomp(I3_, "I3_", "A")







