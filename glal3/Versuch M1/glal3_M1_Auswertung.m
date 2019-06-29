% glal3_M1_Auswertung.m
%% Geschwindigkeit Lichtschranke
clear all; clc; format shorteng;

t_m = 3.2783875e-3;
st = (2.37869188e-3)*1e-3;
d = 0.5;
vm_licht = d/t_m
vmax = d/(t_m - st);
vmin = d/(t_m + st);
vm_licht = mean([vmax, vmin])
sv_licht = vmax - vm_licht

%% Geschwindigkeit mit Pendel
%  gemessene Werte
clc;
g = 9.81;
M = (99.388 + 0.12 + 1)*1e-3;
m = 0.466e-3;
a = 1.955;
x = 0.302819;
T = 3.035127;

v = g/(2*pi) * T * (M+m)/m * x/a * (1 - 3/8*(x/a)^2);

Tmax = 2.83756 + 0.01266;
Tmin = 2.83756 - 0.01266;

vmax = g/(2*pi) * Tmax * (M+m)/m * x/a * (1 - 3/8*(x/a)^2);
vmin = g/(2*pi) * Tmin * (M+m)/m * x/a * (1 - 3/8*(x/a)^2);
vm_pendel = mean([vmax, vmin])

delta_vmax = vmax-v;
delta_vmin = v-vmin;
% sv = vmax-vm;
sv_pendel = vm_pendel-vmin     % absoluter Fehler

% v = vmean ± delta_abs
% (147.3564 ± 0.6574) m/s
%%
% Berechnung des Massenträgheitsmoments der Hantel I_a,h
clc;

M = 0.01556;  % Masse des Zylinders
R = 0.09;     % 
r = 0.0075;
I0 = 7.4*10^-5;

Iah = (7*M*r^2)/6 + 2*M*R^2 + I0
Iah = 2*(1/4*(M*r^2) + 1/12*(M*(2*r)^2) + M*R^2) + I0
% 327.0931e-006

%%
% Geschwindigkeit einer Kugel mit Drehstossprinzip
clc;
Iah = 3.2709e-04;
m = 4.66e-4;
d = 0.0899;
T = 384.29999e-3;
st = (5.17472489367e-1)*1e-3;
w = 2*pi/T;

% v = ((Iah/(m*d))+d)*w
% 129.1229
vmax = ((Iah/(m*d))+d)*2*pi/(T-st);
vmin = ((Iah/(m*d))+d)*2*pi/(T+st);
vm_dreh = mean([vmax, vmin])
sv_dreh = vmax - vm_dreh

%%
% Einfluss des Luftwiderstandes
% Berechnung inkl. statistische Fehler
clc;
m = 4.68e-4;
d = 4.5e-3;
rho = 1.225;
cw = 0.75;

k = (cw * pi*(d/2)^2 * rho)/(2*m)
% 15.6112e-003

% Lichtschranke
disp("Lichtschranke")
s = (0.9-0.4)-301e-3;
vmax = (vm_licht + sv_licht)/(1-k*s);
vmin = (vm_licht - sv_licht)/(1-k*s);
vmk_licht = mean([vmax, vmin])
svk_licht = vmax - vmk_licht

% Ballistisch
disp("Ballistisch")
vmax = (vm_pendel + sv_pendel)/(1-k*s);
vmin = (vm_pendel - sv_pendel)/(1-k*s);
vmk_pendel = mean([vmax, vmin])
svk_pendel = vmax - vmk_pendel

% Drehstoss
disp("Drehstoss")
vmax = (vm_dreh + sv_dreh)/(1-k*s);
vmin = (vm_dreh - sv_dreh)/(1-k*s);
vmk_dreh = mean([vmax, vmin])
svk_dreh = vmax - vmk_dreh

%% statistische Fehler darstellen
clc;

disp("Lichtschranke:")
disp(strcat("vm = (", num2str(vm_licht), " ± ", ...
	num2str(sv_licht), ") m/s"))
disp(strcat("vm = (", num2str(vmk_licht), " ± ", ...
	num2str(svk_licht), ") m/s (korrigiert)"))
disp("Pendel / ballistisch:")
disp(strcat("vm = (", num2str(vm_pendel), " ± ", ...
	num2str(sv_pendel), ") m/s"))
disp(strcat("vm = (", num2str(vmk_pendel), " ± ", ...
	num2str(svk_pendel), ") m/s (korrigiert)"))
disp("Drehstoss:")
disp(strcat("vm = (", num2str(vm_dreh), " ± ", ...
	num2str(sv_dreh), ") m/s"))
disp(strcat("vm = (", num2str(vmk_dreh), " ± ", ...
	num2str(svk_dreh), ") m/s (korrigiert)"))

%% Fehlerrechnung
clear all; clc;
g = 9.81;
M = (99.388 + 0.12 + 1)*1e-3;
m = 0.466e-3;
a = 1.955;
x = 0.302819;
T = 3.035127;

sT = 0.3;      % 300ms
sm = 0.002e-3; % g
sx = 0.005;    % 0.5cm
sTstat = 0.65949;

s2T = ( g/(2*pi) * (M+m)/m * x/a * (1-3/8*(x/a)^2) * sT )^2
s2m = ( g/(2*pi) * T * ( 1/m - (m+M)/m^2 ) * ...
	x/a * (1-3/8*(x/a)^2) * sm )^2
s2x = ((3417249206555533*g*(M + m)*(8*a^2 - 9*x^2))/ ...
	(18014398509481984*a^3*m*pi) *sx)^2
s2stat = ( g/(2*pi) * (M+m)/m * x/a * (1-3/8*(x/a)^2) * sTstat )^2

sv = sqrt( s2T + s2m + s2x + s2stat )








