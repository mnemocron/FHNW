%******************************************************************************
% \details     : digitale Signalverarbeitung - Test 1
% \autor       : Simon Burkhardt
% \file        : dsvgl_FS19_Test_1.m
% \date        : 08.04.2019
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;



syms z
H = 3*z/(z^2 - z*1/4 -1/8);

H_z = H/z;
H_z = partfrac(H_z, z, 'Factormode', 'full');
pretty(H_z)

