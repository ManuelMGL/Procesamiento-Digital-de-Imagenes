function S = adaptive_filter_median(G, masc_size)

G = double(G);

[M, N] = size(G);
d = (masc_size - 1) / 2;

% Imagen rellena de los bordes considerando el tamaño máximo de la máscara
G2 = padarray(G, [d d], 'replicate');

S = zeros(M, N);

for i = 1:M
    for j = 1:N
        
        iast = i+d;
        jast = j+d;
        
        centerSmax = d + 1;
        S_max = G2(iast-d:iast+d, jast-d:jast+d);
        
        S_xy = S_max(centerSmax-d:centerSmax+d, centerSmax-d:centerSmax+d);
       
        S(i, j) = LevelA(S_xy, S_max, 1);
        
    end
end




end


function out = LevelA(S_xy, S_max, d)

z_min = min(S_xy(:));
z_max = max(S_xy(:));
z_med = median(S_xy(:));

size_S_xy = size(S_xy, 1);
size_S_max = size(S_max, 1);

x = (size_S_xy - 1)/2 + 1;
y = (size_S_xy - 1)/2 + 1;

xast = (size_S_max - 1)/2 + 1;
yast = (size_S_max - 1)/2 + 1;

z_xy = S_xy(x, y);

if z_med > z_min && z_med < z_max
    out = LevelB(z_xy, z_med, z_min, z_max);
else
    % Aumentar el tamaño de Sxy
    d = d + 1;
     
    if xast < d
        S_xy = S_max(xast-d:xast+d, yast-d:yast+d);
        
        out = LevelA(S_xy, S_max, d);
    else
        out = z_med;
    end
        
end

end


function out = LevelB(z_xy, z_med, z_min, z_max)

if z_xy > z_min && z_xy < z_max
    out = z_xy;
else
    out = z_med;
end
end

