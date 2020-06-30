function [ h ] = invgf256( b )
    hx = bitget(hex2dec(b), 9:-1:1);
    gx = bitget(hex2dec('11b'), 9:-1:1);  % x^8 + x^4 + x^3 + x + 1
    mx = gx;
    s2 = [0 0 0 0 0 0 0 0 1];
    s1 = [0 0 0 0 0 0 0 0 0];
    t2 = [0 0 0 0 0 0 0 0 0];
    t1 = [0 0 0 0 0 0 0 0 1];
    while(any(hx))
        % a.
        n = find(hx == 1);
        hxs = hx(n(1):length(hx));
        [qx, rx] = deconv(gx, hxs);
        qx = mod(qx, 2);
        rx = mod(rx, 2);
        % b.
        temp = conv(qx, s1);
        [qq, temp] = deconv(temp,mx);  % mod Gen. Poly
        temp = temp(length(temp)- 8:length(temp)); % resize
        sx = s2 - temp;
        
        temp = conv(qx, t1);
        [qq, temp] = deconv(temp,mx);  % mod Gen. Poly
        temp = temp(length(temp)- 8:length(temp)); % resize
        tx = t2 - temp;
        % c.
        gx = hx; 
        hx = rx;
        % d.
        s2 = s1; 
        s1 = sx;
        t2 = t1; 
        t1 = tx;
    end
    h = dec2hex(polyval(mod(t2(length(t2)-7:length(t2)),2),2));
end
