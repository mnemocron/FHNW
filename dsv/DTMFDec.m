
function [ found ] = DTMFDec(y, fs, N)

Y = fft(y);

Ya = abs(Y(1:N/2));
% [a,b] = max(Ya);
[val, ind] = sort(Ya);

f1_ind = ind(length(ind));
f2_ind = ind(length(ind)-1);
% f1 = Ya(f1_ind);
% f2 = Ya(f2_ind);

freqs = (sort([f1_ind, f2_ind]) -1).*fs./(N-1);

% f = linspace(0, fs, N);
% stem(f(1:N/2), abs(Y(1:N/2)));
% grid on
% hold on
% plot(freqs(1), Ya(f2_ind), "x")
% plot(freqs(2), Ya(f1_ind), "x")

a = 0; b = 0;
deviation = 20;
if abs(freqs(1) - 697) < deviation
    a = 1;
elseif abs(freqs(1) - 770) < deviation
    a = 2;
elseif abs(freqs(1) - 852) < deviation
    a = 3;
elseif abs(freqs(1) - 941) < deviation
    a = 4;
end

if abs(freqs(2) - 1209) < deviation
    b = 1;
elseif abs(freqs(2) - 1336) < deviation
    b = 2;
elseif abs(freqs(2) - 1477) < deviation
    b = 3;
elseif abs(freqs(2) - 1633) < deviation
    b = 4;
end

symbs = [ "1", "2", "3", "A";
          "4", "5", "6", "B";
          "7", "8", "9", "C";
          "*", "0", "#", "D"];
      
found = symbs(a, b);

end
