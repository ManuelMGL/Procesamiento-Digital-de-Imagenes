function J = interpola_tile(tile, T11, T12, T21, T22)

[M,N] = size(tile);

J = zeros(M,N,'uint8');

for y = 1:M
    
    dy = (y-1)/(M-1);
    
    for x = 1:N
        
        dx = (x-1)/(N-1);
        
        w1 = (1-dx)*(1-dy);
        w2 = dx*(1-dy);
        w3 = (1-dx)*dy;
        w4 = dx*dy;
        
        p = tile(y,x);
        
        val = w1*T11(p+1) + ...
              w2*T12(p+1) + ...
              w3*T21(p+1) + ...
              w4*T22(p+1);
          
        J(y,x) = uint8(round(val));
        
    end
    
end

end