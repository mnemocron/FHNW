%******************************************************************************
% \details     : Animation to display the poles of a transfer function in 
%                dependence of the parameter qp
% \autor       : Simon Burkhardt
% \file        : siv_animation_of_poles.m
% \date        : 23.11.2018
% \version     : 1.0
%******************************************************************************
clear all; close all; clc;
format shorteng;

% s-plane (sigma + j*w)
sig = -100:1:100;
jw  = -100:1:100;

[SIG, JW] = meshgrid(sig, jw);

% initial values to draw the figure
wp = 50;    % fixed so that the radius is half the axis limits (100)
qp = 1;

s = SIG+JW.*j;  % s-Matrix

% function
T = abs((wp.*s)./((s.^2) + (wp.*s./qp) + (wp.^2)));
Tmax = 10;

fig = surf(SIG,JW,T);
axis([-100 100 -100 100 0 Tmax]);  % keep the z-axis steady
xlabel sigma
ylabel jw
zlabel '|T_{(jw)}|'
shading interp
% fig.EdgeColor = 'none';
view(20, 70);

% add a plane to the jw-axis
jwx = -100:10:100;
jwy = 0:10:10;
[Jx Jy] = meshgrid(jwx, jwy);
Jz = (Jx.*Jy.*0); % zeroes
hold on
axisfig = surf(Jz, Jx, Jy);
hold off

% animation
steps = 10e3;   % vary this to play with the animation speed
for n=1:steps
    qp = (n)/steps*2;
    T = abs((wp.*s)./((s.^2) + (wp.*s./qp) + (wp.^2)));
    T = min(T,Tmax);
    fig.ZData = abs(T);
    drawnow limitrate 
    view(-40+(n/steps)*40, 70);   % automatic rotation of the figure
end





