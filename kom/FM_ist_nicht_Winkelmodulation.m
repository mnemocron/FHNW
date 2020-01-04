






t = linspace(0,1,1e3);

Smd = 1;
wm = 2*pi*1;
sm = @(t) Smd * cos(wm*t);

Smf = 1;
wt = 2*pi*20;
dO = 2*pi*10/Smd;

eta = dO/wm;

% FM falsch Frequenzparameter wird moduliert
% st = @(t) Smf * cos( t.*(wt + sm(t)*dO) ) 

% FM richtig "Winkel" wird moduliert
st = @(t) Smf * cos(wt*t + eta*sin(wm*t));  

smt = sm(t);
smf = st(t);

plot(t, smt); hold on
plot(t, smf)








