function [ res ] = four_an(f, T, t0)
%FOURIERANALYSIS
%
% [ res ] = fourieranalysis(f, T, t0, plt)
%
% input parameters:
% f       function (f @(x) format)
% T       period for plots (double)
% t0      period start-value (double)
% plt     draw plot (boolean)
% spctrm  calculate spectrum (boolean)
%
% output parameters [res.xxx]:
% a0      a0
% a(n)    an
% b(n)    bn
% c0      c0
% c(n)    cn
% r(x,n)  fourier symsum (real)
% h(x,k)  fourier series (real)
% rr(x,n) fourier symsum (imag)
% hh(x,k) fourier series (image)
% A       amplitude
% phi     phase
% F(n)    average square error
%
%   See also: FOURIER

%------------------------------------------------------------------------------
% Fourier Analysis
%------------------------------------------------------------------------------

%% Input Check
% check if 3 parameters are provided
if (nargin < 3)
    error('you have to provide at least f, t and t0')
end

%% Initialization
syms x n k
assume(n, 'integer');
assume(k, 'integer');
t_e=t0+T;    % period end-value
w0=2*pi*1/T;  % angular frequency
T=sym(T);     % symbolic period for cofficients
%AAAAAAAAAAAAAAAAAAHHHH!! TTT

%% Fourier-Coefficients (real)
a0=2/T*int(f(x),x,t0,t_e);
res.a0=simplify(simplifyFraction(a0));
a(n)=2/T*int(f(x)*cos(n*w0*x),x,t0,t_e);
res.a(n)=simplify(simplifyFraction(a(n)));
b(n)=2/T*int(f(x)*sin(n*w0*x),x,t0,t_e);
res.b(n)=simplify(simplifyFraction(b(n)));
disp(['a0: ', char(res.a0)])
disp(['an: ', char(res.a(n))])
disp(['bn: ', char(res.b(n))])

%% Fourier-Series (real)
r(x,n)=a(n)*cos(n*w0*x)+b(n)*sin(n*w0*x);
res.r(x,n)=simplify(r(x,n));
h(x,k)=a0/2+symsum(r(x,n),n,1,k);
res.h(x,k)=simplify(h(x,k));
disp(['Fourier-symsum (real): ', char(res.r(x,n))])
disp(['Fourier-series (real): ', char(res.h(x,k))])

%% Fourier-Coefficients (imaginary)
c0=1/T*int(f(x),x,t0,t_e);
res.c0=simplify(simplifyFraction(c0));
c(n)=1/T*int(f(x)*exp(-j*n*w0*x),x,t0,t_e);
res.c(n)=simplify(simplifyFraction(c(n)));
disp(['c0: ', char(res.c0)])
disp(['cn: ', char(res.c(n))])

%% Fourier-Series (imaginary)
rr(x,n)=c(n)*exp(j*n*w0*x);
res.rr(x,n)=simplify(rr(x,n));
hh(x,k)=c0+symsum(rr(x,n),n,0,k);
res.hh(x,k)=simplify(hh(x,k));
disp(['Fourier-symsum (imag): ', char(res.rr(x,n))])
disp(['Fourier-series (imag): ', char(res.hh(x,k))])

%% Fourier-Series (phase/amplitude)
A(n)=abs(c(n));
res.A(n)=simplify(A(n));
phi(n)=angle(c(n));
res.phi(n)=simplify(phi(n));
disp(['A:   ', char(res.A(n))])
disp(['phi: ', char(res.phi(n))])

%% Average Square Error
res.F(k)=int(f(x)^2,x,t0,t_e)-(T/2)*(a0^2/2+symsum(a(n)^2+b(n)^2,n,1,k));

end
