clear all; clc;

% d zu Lambda
d_L = 0.5;

% Anzahl Elemente
n = 8;

anzp = 300;
psi_d = linspace(0,180,anzp);
psi_r = deg2rad(psi_d);

anzp = 300;

s = 0;

re=0;
im=0;

for phi=0:180
    s=0;
    re=0;
    im=0;
    for k=1:n
        phase=d_L*2*pi*cos(deg2rad(phi))*(k-1);
        s=s+cos(phase)+j*sin(phase);
        re(k)=cos(phase);
        im(k)=sin(phase);
    end;
    % intens(phi+1) = s;
    im_l=0;re_l=0;
    for k=1:length(im)
        im_l=im_l+im(k);
        re_l=re_l+re(k);
    end;
    intens(phi+1) = sqrt(im_l^2+re_l^2);
end;

% Normierung
sn=abs(intens)/max(abs(intens));

sndb=20*log10(sn);
plot(linspace(0,180,181),sndb), grid on;
axis([0 180 -40 0]);
title('Strahlungsdiagramm eines linearen Arrays');