%**************************************************************************
% \details     : WST Klassen Zugfestigkeit
% \autor       : Simon Burkhardt
% \file        : wst_2_2_1_Zugfestigkeit_Klassen.m
% \date        : 01.03.2019
%**************************************************************************

clear all; clc;
format shorteng;

messung = [404 413 390 418 387 418 399 392 399 417 390 384 ...
    383 387 389 391 411 422 371 369 411 405 408 349 402 378 ...
    393 424 403 414 367 407 383 401 388 386 427 411 400 412 ...
    426 392 402 392 373 390 396 408 386 396];
messung = sort(messung);

n = length(messung);  % Datenpunkte
k = sqrt(n)           % Anzahl Klassen ~~
k = 9;
x_min = min(messung)
x_max = max(messung)
x_min = 345;
x_max = 435;
d = (x_max - x_min)/k

liste = [];
klassen = [];
for a=1:k
    g_unten = x_min + (a-1)*d;
    g_oben = x_min + (a)*d;
    klassen(a) = length(messung( messung>=g_unten & messung<g_oben ));
    [g_unten g_oben klassen(a)];
end
klassen'
