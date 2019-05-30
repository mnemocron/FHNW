


clear all; clc; close all;
format shorteng


d0 = 1;
d1 = 2;
d2 = 1;
c1 = -1.937;
c2 = 0.94;

x = zeros(1, 300);
y = zeros(1, 300);

offset = 10;
x(offset) = 1;       % Kronecker Delta


for k=1+offset:length(x)
    y(k) = d0*x(k) + d1*x(k-1) + d2*x(k-2) - c1*y(k-1) - c2*y(k-2);
end

% plot(linspace(0, length(y), length(y)), y);
% hold on; grid on;
% plot(offset, 1, 'o')
% plot([offset, offset], [0,1])   % Kronecker Delta

stem(linspace(0, length(y), length(y)), y);


%%
% Spielereien
clear all; clc; close all;
format shorteng

% t = linspace(0, 1e3, 1e3);
% Ts = 1/(1e3);
% f = 1/Ts;
% w = 2*pi*f;
% 
% a = sin(1.*w.*t);
% b = sin(2.*w.*t);
% c = sin(10.*w.*t);
% 
% ya = filt(a);
% yb = filt(b);
% yc = filt(c);
% 
% plot(t, a, 'r'); hold on;
% plot(t, b, 'r');
% plot(t, c, 'r');
% plot(t, ya, 'b'); grid on;
% plot(t, yb, 'b');
% plot(t, yc, 'b');

[wave,fs] = audioread('our_parents.wav');
t = linspace(0, length(wave)/fs, length(wave));

wave2 = filt(wave);

plot(t, wave, 'r'); hold on
plot(t, wave2, 'b'); 

audio1 = audioplayer(wave, fs);
audio2 = audioplayer(wave2, fs);


function y = filt(x)
    d0 = 1;
    d1 = 2;
    d2 = 1;
    c1 = -1.937;
    c2 = 0.94;
    y = zeros(1, length(x));
    for k=1+2:length(x)
        y(k) = d0*x(k) + d1*x(k-1) + d2*x(k-2) - c1*y(k-1) - c2*y(k-2);
    end
    y = y./800;
end










