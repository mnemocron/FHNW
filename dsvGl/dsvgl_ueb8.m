%**************************************************************************
% \details     : digitale Signalverarbeitung - U8
% \autor       : Simon Burkhardt
% \file        : dsvgl_ueb8.m
% \date        : 03.05.2019
% \version     : 1.0
%**************************************************************************

%%
% Aufgabe 1
% c)
clear all; clc; format shorteng;
fg = 1;
fs = fg*8;
Ts = 1/fs;

k = -20:20;
% t = k*Ts+eps;
t = k*Ts;
h = sin(2*pi*fg*t)./(pi*t);
h(21)=2*fg; %Definieren des Wertes für k=0 
h = h/(2*fg);  % Skalierungsfaktor

stem(k,h)

L = length(k);
offset = (L-1)/2
offset = 19;

%%
% e)
fvtool(h);

%%
% f)
w=hamming(41);

%%
% g)
hw = w' .* h;
stem(k, hw)
%%
fvtool(hw)

%%
%**************************************************************************
% Aufgabe 2
% 
clear all; clc; format shorteng;
fg = 1;

t = linspace(-5, 5, 1e3);
h = ( 2.*pi.*fg.*t.*cos(2.*pi.*fg.*t)-sin(2.*pi.*fg.*t) ) ./ (pi.*t.^2);
plot(t, h);
grid on;
%%
% c)
Ts = 0.25;

L = 21
tau = (L-1)/2*Ts

k = -floor(L/2) : floor(L/2);
t = k.*Ts;
h = Ts * ( 2.*pi.*fg.*t.*cos(2.*pi.*fg.*t)-sin(2.*pi.*fg.*t) ) ./ (pi.*t.^2);
h(11) = 0;
stem(k, h)
%%
% d)
fvtool(h)

%%
% e)
w=hamming(21);
hw = w' .* h;
stem(k, hw)
fvtool(hw)

%%
%**************************************************************************
% Aufgabe 3
clear all; clc; 
fg = 1;

L = 21;
k = -(L-1)/2 : (L-1)/2;

h = 2/pi * (-1).^k ./ (1-4*k.^2);
stem(k, h)
% fvtool(h)
%%
T = 1;
f = linspace(-1, 1, 1e3);

H = [];     % komplexer Frequenzgang
for k=1:length(f) % Frequenzgang
    Hf = 0;
    for k=1:length(h) % Koeffizienten der z-Übertragungsfunktion
        Hf = Hf + h(k)*exp(-j*2*pi*f(n)*T*k);
    end
    H = [H, Hf];
end

plot(f, abs(H));
grid on;

%%
%**************************************************************************
% Aufgabe 4
% a)
clear all; clc; 

syms a

L = 4;
H = [1 a 0 a'];

n = 0:L/2;
phi = -(L-1)/L*pi*n;

h = ifft(H);
stem(h)













