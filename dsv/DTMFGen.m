


function [ y ] = DTMFGen( symbol, fs, N )

freqs = [ 1, 1 ];

if contains(symbol, ["1", "2", "3", "a", "A"])
    freqs(1) = 697;
elseif contains(symbol, ["4", "5", "6", "b", "B"])
    freqs(1) = 770;
elseif contains(symbol, ["7", "8", "9", "c", "C"])
    freqs(1) = 852;
elseif contains(symbol, ["*", "0", "#", "d", "D"])
    freqs(1) = 941;
end

if contains(symbol, ["1", "4", "7", "*"])
    freqs(2) = 1209;
elseif contains(symbol, ["2", "5", "8", "0"])
    freqs(2) = 1336;
elseif contains(symbol, ["3", "6", "9", "#"])
    freqs(2) = 1477;
elseif contains(symbol, ["a", "A", "b", "B", "c", "C", "d", "D"])
    freqs(2) = 1633;
end

% freqs

Ts = 1/fs;

% N Abtastwerte, mit Samplingrate fs
t = linspace(0, N*Ts, N);

y = 1*sin(2*pi*freqs(1)*t) + 1*sin(2*pi*freqs(2)*t);

end




