%**************************************************************************
% \details     : digitale Signalverarbeitung - Filter Algorithmen
% \autor       : Simon Burkhardt
% \file        : dsvgl_algorithmen_ausprobieren.m
% \date        : 20.05.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;

% x-Axis
f = [0 0.6 0.6 1];

% Amplidude / Magnitude
m = [1 1 0 0];

[b, a] = yulewalk(8, f, m)

fvtool(b,a)

