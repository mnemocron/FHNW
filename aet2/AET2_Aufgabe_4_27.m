% 4-27
clear; clc;
format shorteng;

R=10; 
L=20e-3;
f=50;
w=2*pi*f;
% a)
Z=R+(j*w*L)
Y=1/Z

I=5*exp(j*0);
% b)
S=abs(I)^2*Z
S=abs(I)^2*(R + j*w*L)
P=real(S)
Q=imag(S)
% S=abs(S)*exp(j*angle(S))
% S=2295.25 /_ 32.14°

Pmax=P+abs(S)
Pmin=P-abs(S)

P==1/2*(Pmax+Pmin)
abs(S)==1/2*(Pmax-Pmin)
abs(Q)==sqrt(-Pmax*Pmin)


% Visualisierung
clear; clc;

I=5+j*0;
w=2*pi*50;
R=10; L=20e-3;
t=linspace(0, 2.5*20e-3, 1e3);
i=abs(I)*sqrt(2)*cos(w*t+angle(I));

Z=R+j*w*L;

S=abs(I)^2*Z;
P=real(S);
Q=imag(S);

U=Z*I;
UL=j*w*L*I;

u=abs(U)*sqrt(2)*cos(w*t+angle(U));
uL=abs(UL)*sqrt(2)*cos(w*t+angle(UL));
% plot(t, i.*10, "red", t, u), grid on;

p=u.*i;
% plot(t,p), grid on;
pmax=max(p)
pmin=min(p)

pR=i.^2*R;
pL=uL.*i;
% plot(t,p,t,pR), grid on;
figure(1);
% plot(t,p, t, pL), grid on;
plot(t,p, t, pL), grid on;
figure(2);
plot(t, p-pR-pL), gird on;




