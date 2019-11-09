

clear all; clc;
format shorteng;

fs = 8000;
t_d = 0.15
pause = zeros(1, round(t_d*fs/2));

t = linspace(0, t_d, fs);

% plot(t(1:400), y(1:400));
% hold on;
% 
% y = DTMFGen("b", fs, fs);
% plot(t(1:400), y(1:400))

sound = [pause];

y = DTMFGen("0", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("7", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("8", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("9", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("5", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("6", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("4", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("9", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("8", fs, t_d*fs);
sound = [sound, y, pause];
y = DTMFGen("0", fs, t_d*fs);
sound = [sound, y, pause];

soundsc(sound, fs);



