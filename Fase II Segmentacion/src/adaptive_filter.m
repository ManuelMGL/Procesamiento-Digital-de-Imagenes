function F = adaptive_filter(G, masc_size, factor)

G = double(G);

[M, N] = size(G);


d = (masc_size - 1) / 2; 

Var_Global = calculateVAR(G, 1)/factor;

G2 = padarray(G, [d d], 'replicate');

F = zeros(M, N);

for i = 1:M
    for j = 1:N
        
        iast = i+d;
        jast = j+d;
        
        Sxy = G2(iast-d:iast+d, jast-d:jast+d);        
        
        Var_Local = calculateVAR(Sxy, 0);
        Zxy = mean(Sxy(:));
        
        RATIO = min(1, Var_Global / Var_Local);
        
        F(i, j) = G2(iast, jast) - RATIO * (G2(iast, jast) - Zxy);
        
    end
    
end

end

function Var = calculateVAR(I, gbl)

m = mean(I(:));
sum_data = I(:) - m;
exp_data = sum_data.^2;

if gbl ~= 0
    Var = sum( exp_data(:) ) / ( numel(exp_data(:)) );
else
    Var = sum( exp_data(:) ) / ( numel(exp_data(:))-1 );
end

end



