%**************************************************************************
% \details     : WST Ausfalltage von Bagger
% \autor       : Simon Burkhardt
% \file        : wst_hausaufgabe_2_histogram_bagger.m
% \date        : 23.02.2019
%**************************************************************************

clear all; clc;

ausfalle = [48, 38, 10, 4];

dpoints = []
for n=1:length(ausfalle)
    dpoints = [dpoints ones(1, ausfalle(n)).*(n-1)];
end

histogram(dpoints)
xlabel('Tage mit x Ausfällen')
ylabel('Anzahl Tage')
title('Häuffigkeit der Ausfalltage')


