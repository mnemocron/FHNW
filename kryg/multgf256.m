function [ h ] = multgf256( b, c )
    b = hex2dec(b);
    c = hex2dec(c);
    y = b*c;
    if(y > 255)
        poly = hex2dec('11b');  % x^8 + x^4 + x^3 + x + 1
        y = bitxor(y, poly);
    end
    h = dec2hex(y);
end
