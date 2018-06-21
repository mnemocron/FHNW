%******************************************************************************
% \details     : AET2 Aufgabe 4-90
% \autor       : Simon Burkhardt
% \file        : AET2_Aufgabe_4_90.m
% \date        : 19.06.2018
% \version     : 1.0
%******************************************************************************
clear all; clc
format shorteng

Zq_ = 20 - j*10;
Zl_ = 100 + j*30;

syms X3 X4

gl1 = Zq_ == X3 + 1/( 1/(X4) + 1/(Zl_) );
gl2 = Zl_ == 1/( 1/(X4) + 1/(X3+Zq_) );

a=solve(gl1, gl2);

X3l=double(a.X3(1))
X4l=double(a.X4(1))

% aufschneiden an der Quelle
Zll_ = X3l + par(X4l, Zl_)

% aufschneiden an der Last
Zqq_ = par(Zq_ + X3l, X4l)

