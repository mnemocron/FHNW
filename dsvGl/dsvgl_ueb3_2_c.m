


clear all; clc; format shorteng;


T = 1e-3;

% s=tf('s');
% H = 1 + 0.5*exp(-s*T) + 0.25*exp(-2*s*T);
% bode(H)


f = linspace(0,1e4, 1e6);
H_ = 1 + 0.5.*exp(-j.*2.*pi.*f.*T) + 0.25.*exp(-j.*2.*pi.*f.*T.*2);

subplot(2,1,1);
plot(f, abs(H_)); hold on;
grid on;
ylabel('|H_{(f)}|')
xlabel('f [Hz]')
plot(1/T, 0, 'o');

subplot(2,1,2);
plot(f, rad2deg(angle(H_))); hold on;
grid on;
ylabel('arg(H_{(f)})')
xlabel('f [Hz]')
plot(1/T, 0, 'o');







