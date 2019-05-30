%**************************************************************************
% \details     : WST 1. Semesterpruefung
% \autor       : Simon Burkhardt
% \file        : wst_Pruefung_1_Burkhardt.m
% \date        : 28.03.2019
%**************************************************************************
clear all; clc; close all;
format shorteng;


% Aufgabe 2
data_cars;

% a)
m_speed = mean(data(:,3))
s_speed = std(data(:,3))
% v = 194.412 +/- 104.644 km/h
median_speed = median(data(:,3))
% 151
Q25 = quantile(data(:,3), 0.25) 
% 105

%%
% b)
% BOXPLOT
subplot(2,1,1)
boxplot(data(:,3), 'orientation', 'horizontal', 'whisker', 1.5)
xlabel('Geschwindigkeit [km/h]')
ylabel('')
title('Höchstgeschwindigkeit von Fahrzeugen')

%%
% HISTOGRAM
subplot(2,1,2)
histogram(data(:,3), 10)
xlabel('Höchstgeschwindigkeit [km/h]')
ylabel('Anzahl der Fahrzeuge')
title('Verteilung der Höchstgeschwindigkeiten verschiedener Fahrzeuge')
