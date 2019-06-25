%**************************************************************************
% \details     : WST Serie 12
% \autor       : Simon Burkhardt
% \file        : wst_serie_12.m
% \date        : 06.2019
%**************************************************************************


%%
% 1.
clear all; close; clc; format shorteng;

x = [20 25 30 40 50 60 56 80]; % T
y = [16.3 16.44 16.61 16.81 17.10 17.37 17.38 17.86]; % R

% a) R = a*T +b  (m=a/q=b)
X1 = [ones(length(x),1)  x'];
b = X1\y';
m = b(2)
q = b(1)

%%
% b)
covv = cov(x, y);
sxx = covv(1);
sxy = covv(2);
syx = covv(3);
syy = covv(4);

n = length(x);
rc = corrcoef(x,y);
r = rc(2);

% Varianzen der Regressionsgeraden
sm2 = (1-r^2)*syy/(n-2)/sxx
sq2 = ((n-1)*(sxx)+n*mean(x)^2 )/n*sm2
% Standardabweichungen:
sm = sqrt(sm2)
sq = sqrt(sq2)

%%
% c)
t = linspace(10,90,1e3);
plot(x,y, 'o'); hold on
plot(t, (a.*t+b));


%%
% 3. 
clear all; close; clc; format shorteng;

% y = P = Preis der Häuser
% x = r = Zinssatz
y = [183800, 183200, 174900, 173500, 172900, 173200, 173200, 169700, 174500, 177900, 188100, 203200, 230200, 258200, 309800, 329800];
x = [10.30, 10.30, 10.10, 9.30, 8.40, 7.30, 8.40, 7.90, 7.60, 7.60, 6.90, 7.40, 8.10, 7, 6.50, 5.80 ];
z = [1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003];

% a)
X1 = [ones(length(x),1)  x'];
b = X1\y';
m = b(2)
q = b(1)

%%
% b)
covv = cov(x, y);
sxx = covv(1);
sxy = covv(2);
syx = covv(3);
syy = covv(4);

n = length(x);
rc = corrcoef(x,y);
r = rc(2);

% Varianzen der Regressionsgeraden
sm2 = (1-r^2)*syy/(n-2)/sxx;
sq2 = ((n-1)*(sxx)+n*mean(x)^2 )/n*sm2;
% Standardabweichungen:
sm = sqrt(sm2)
sq = sqrt(sq2)

%%
% c)
alpha = 0.1;
quant = tinv(1-alpha/2, n-1 );
me = [m-sm*quant/sqrt(n), m+sm*quant/sqrt(n)]
qe = [q-sq*quant/sqrt(n), q+sq*quant/sqrt(n)]


















