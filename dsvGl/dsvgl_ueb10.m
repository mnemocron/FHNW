%**************************************************************************
% \details     : digitale Signalverarbeitung - Uebung 10
% \autor       : Simon Burkhardt
% \file        : dsvgl_ueb10.m
% \date        : 18.05.2019
% \version     : 1.0
%**************************************************************************
clear all; close all; clc;
format shorteng;
% Aufgabe 1
wg = 2*pi*10e3;
fs = 20e3; Ts = 1/fs;
s = tf('s');
Hs = s/(s+wg);
bode(Hs);
% a) Hochpass
%%
clear s Hs; clc
syms s z
Hs = s/(s+wg);
% Bilineare Transformation
s = subs(s, 2/Ts*(z-1)/(z+1));
Hz = Hs;
Hz = subs(Hz);
pretty(simplify(Hz))
%       2 z - 2
% -------------------
% 2 z + pi + pi z - 2

%%
% fa = 1/(2*pi) * 2/Ts * tan(2*pi*fd * Ts/2)
% fd = 1/(2*pi) * 2/Ts * atan(2*pi*fa *Ts/2)
% wa = 2/Ts * tan(wd * Ts/2)
% wd = 2/Ts * atan(wa * Ts/2)
fd = 1/(2*pi) * 2/Ts * atan(wg *Ts/2)

%**************************************************************************
%%
% Aufgabe 2
clear all; clc;
syms s a b Ts
Hs = b/(s^2 + a*s + b);

% a)
denom = (s^2 + a*s + b);
poles = solve(denom==0, s)
pretty(simplify(poles))
% /             2        \
% |   a   sqrt(a  - 4 b) |
% | - - - -------------- |
% |   2          2       |
% |                      |
% |        2             |
% |  sqrt(a  - 4 b)   a  |
% |  -------------- - -  |
% \         2         2  /
%%
% b)
% z = e^j 2 pi f Ts
zpoles = exp(j*poles*Ts);
pretty(simplify(zpoles))

%%
% c)
syms z
s = subs(s, 2/Ts*(z-1)/(z+1));
Hz = Hs;
Hz = subs(Hz);
pretty(simplify(Hz))


%%
% d)
clear all; clc;
a = 2; b = 2; Ts = 1;
f = linspace(0, 0.5, 1e3);
s = j*2*pi*f;
z = (2./Ts+s)./(2./Ts-s);
Hs = b./(s.^2 + a*s + b);
Hsdb = 20*log10(Hs);
% Hz = b./(b + (4.*(z - 1).^2)./(Ts.^2.*(z + 1).^2) ...
%     + (2.*a.*(z - 1))./(Ts.*(z + 1)));
Hz = 0.73 * (z)./(z.^2 - 0.3975.*z + 0.135);
Hzdb = 20*log10(Hz);

plot(f, Hsdb); hold on;
plot(f, Hzdb); grid on;
legend('analog', 'digital')


%**************************************************************************
%%
% Aufgabe 3
clear all; clc;

%              -1
%      2 - 0.5z
% -------------------
%       -1       -2
%  1 + z   + 0.5z

num = [2 -0.5];
den = [1 1 0.5];

fvtool(num, den);

%**************************************************************************
%%
% Aufgabe 4
clear all; clc;
syms Tau s z
Hs = 1/(1+s*Tau) * 1/(1+s*Tau+ (s*Tau)^2);
% pretty(Hs);
Ts = Tau/2;
s = subs(s, 2/Ts*(z-1)/(z+1));
Hz = subs(subs(Hs));
% a)
pretty(simplify(Hz))
%                  3
%           (z + 1)
% ----------------------------
%      3        2
% 105 z  - 213 z  + 155 z - 39

%%
% b)
% Nullstellen:
% 3-fache Nullstelle z = -1
% Pole:
[N, D] = numden(Hz);
% reverse order of coefficients!
num = fliplr(double(coeffs(expand(N))))
den = fliplr(double(coeffs(expand(D))))

%%

den = 105*z^3 - 213*z^2 + 155*z - 39;
poles = solve(den == 0, z);
pretty(poles)
% /        3       \
% |        -       |
% |        5       |
% |                |
% | 5   sqrt(3) 4i |
% | - - ---------- |
% | 7       21     |
% |                |
% | sqrt(3) 4i   5 |
% | ---------- + - |
% \     21       7 /

%%
% c)
% ??????

%%
% d)
clear all; clc;
Tau = 0.1;
f = linspace(0, 10, 1e3);
s = j.*2.*pi.*f;
Hs = 1./(1+s.*Tau) .* 1./(1+s.*Tau+ (s.*Tau).^2);

% subplot(2,1,1);
% plot(f, abs(Hs)); grid on
% title('Amplitudengang')
% xlabel('f [Hz]')
% ylabel('|Amplitude|')
% subplot(2,1,2);
% plot(f, angle(Hs)); grid on
% title('Phasengang')
% xlabel('f [Hz]')
% ylabel('Phase')

s = tf('s')
Hs = 1/(1+s*Tau) * 1/(1+s*Tau+ (s*Tau)^2);
bode(Hs)

%%
% e)
clear all; clc;
format short
Tau = 0.1;
Ts = Tau/2;

num_a = 1;
den_a = [Tau^3 2*Tau^2 2*Tau 1];

[num_d, den_d] = bilinear(num_a, den_a, 1/Ts);
num_d = num_d.*105
den_d = den_d.*105

upper = length(num_d);
numerator = strcat(num2str(num_d(1)), "z^", num2str(upper-1));
for k=2:length(num_d)
    numerator = strcat(numerator, " + ", num2str(num_d(k)), "z^", num2str(upper-k));
end
upper = length(den_d);
denumerator = strcat(num2str(den_d(1)), "z^", num2str(upper-1));
for k=2:length(num_d)
    denumerator = strcat(denumerator, " + ", num2str(den_d(k)), "z^", num2str(upper-k));
end
disp(numerator)
disp(denumerator)

%%
% f)
clear all; clc;
format short
num = [1.0000    3.0000    3.0000    1.0000];
den = [105.0000 -213.0000  155.0000  -39.0000];
% fvtool(num, den);

% z = exp(j*2*pi*f*T)
f = linspace(0, 7, 1e3);
s = j.*2.*pi.*f;
Tau = 0.1;
Ts = Tau/2;
z = exp(s.*Ts);

Hs = 1;

numer = 1;
for k=1:length(num)
    numer = numer + num(k).*z.^(length(num)-k);
end
denum = 1;
for k= 1:length(den)
    denum = denum + den(k).*z.^(length(den)-k);
end
Hs = numer./denum;

subplot(2,1,1);
plot(f, 20.*log10(abs(Hs)) ); grid on
title('Amplitudengang')
xlabel('f [Hz]')
ylabel('|Amplitude| [dB]')
subplot(2,1,2);
plot(f, angle(Hs)); grid on
title('Phasengang')
xlabel('f [Hz]')
ylabel('Phase')

%**************************************************************************
%%
% Aufgabe 5
clear all; clc;
fs = 35e3; Ts = 1/fs;
% Tiefpassfilter

f1 = 2.7e3;  X1 = 2.5; Y1 = 2.2075;
f2 = 10.5e3; X2 = 2.8; Y2 = 0.03052;

wd1 = 2*pi*f1;
wd2 = 2*pi*f2;
wa1 = 2/Ts * tan(wd1 * Ts/2)
wa2 = 2/Ts * tan(wd2 * Ts/2)

% TODO - Kolloquium

%**************************************************************************
%%
% Aufgabe 6
clear all; clc;
% a) Impulsinvariante Transformation mit z-Transformation
fs = 1; Ts = 1/fs;
syms B a k
hk = 1/Ts * 1/B *exp(-a*k) * sin(B*k);
Hz = ztrans(hk)
pretty(Hz)

%%
a = subs(a, 0.5);
B = subs(B, sqrt(0.09));
Hz = simplify(subs(Hz));
pretty(Hz)
[N, D] = numden(Hz);
% reverse order of coefficients!
num = fliplr(double(coeffs(N)))
den = fliplr(double(coeffs(D)))
fvtool(num, den)
% STIMMT NICHT MIT LÖSUNG ÜBEREIN !

%%
f = 0;
s = j*2*pi*f;
Hs_f = 1/( (s*Ts + 0.5)^2 + 0.09 );
Gain_analog_0 = abs(Hs_f)

z = 1;
Gain_digital_1 = num(1)*z/(den(1))









