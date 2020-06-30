function [ h ] = xtimes( c ) 
    b = hex2dec(c);
    b = b*2;
    if(b > 255)
        m = hex2dec('11b');  % x^8 + x^4 + x^3 + x + 1
        b = bitxor(b, m);
    end
    h = dec2hex(b);
end
