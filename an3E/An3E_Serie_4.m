%******************************************************************************
% \details     : An3E Serie 1
% \autor       : Simon Burkhardt
% \file        : An3E_Serie_4.m
% \date        : 14.10.2018
% \version     : 1.0
%******************************************************************************
%% Aufgabe 1

clear all; clc
format shorteng

syms x n
assume(n, 'integer')

T = 2*pi;
w0 = 2*pi/T;
f(x) = piecewise(-pi<=x<0, pi+x, 0<=x<=pi, pi);

lsg=four_an(f, 2*pi, -pi);

lsg.c


