%**************************************************************************
% \details     : Theoriekurve Gleichung 6 für E4.3
% \autor       : Simon Burkhardt
% \file        : glal4_phys_e4_3_theorie_gleichung_6.m
% \date        : 19.04.2019
% \version     : 1.0
%**************************************************************************

I = 0.6; % (Konstante)
N = 474; % (Konstante)
R = 0.014; % (Konstante)
len = 0.068; % (Konstante)
mu0 = pi*4e-7; % (Konstante)
% z0 = -3.4840886454754e-02 +/- 1.2919571173011e-04
% z0 = -3.4840886454754e-02;
z0 = -0.03;

B = @(z) (mu0 .* N .* I)./len  .* 1./2.*( ( (len./2 + (z-z0))./sqrt( (len./2+(z-z0)).^2 + R.^2) ) ...
    + ( (len./2 - (z-z0))./sqrt( (len./2-(z-z0)).^2 + R.^2) ) );



lm = 0.025; % Länge des Magneten (N-S)
dm = 0.0184;  % Durchmesser
Am = (dm/2)^2*pi;
Br = 0.0012;
% Br = 0.05;

% F = @(z) Br./mu0.*Am.* ( B(z) - B(z+lm) );

% F = @(z) Br./mu0.*Am.* ...
%     ( (mu0 .* N .* I)./len  .* 1./2.*( ( (len./2 + (z-z0))./sqrt( (len./2+(z-z0)).^2 + R.^2) ) ...
%     + ( (len./2 - (z-z0))./sqrt( (len./2-(z-z0)).^2 + R.^2) ) ) - ...
%     (mu0 .* N .* I)./len  .* 1./2.*( ( (len./2 + (z+lm-z0))./sqrt( (len./2+(z+lm-z0)).^2 + R.^2) ) ...
%     + ( (len./2 - (z+lm-z0))./sqrt( (len./2-(z+lm-z0)).^2 + R.^2) ) ) );

F = @(x) Br/mu0*pi*(dm/2)^2 * ( (mu0 * N * I)/len  * 1/2*( ( (len/2 + (x-z0))/sqrt( (len/2+(x-z0))^2 + R^2) ) + ( (len/2 - (x-z0))/sqrt( (len/2-(x-z0))^2 + R^2) ) ) - (mu0 * N * I)/len  * 1/2*( ( (len/2 + (x+lm-z0))/sqrt( (len/2+(x+lm-z0))^2 + R^2) ) + ( (len/2 - (x+lm-z0))/sqrt( (len/2-(x+lm-z0))^2 + R^2) ) ) );



z = linspace(20e-3, -140e-3, 1e3);
Fz = z;
for k=1:length(z)
    Fz(k) = F(z(k));
end

plot(z, Fz); grid on; hold on;

