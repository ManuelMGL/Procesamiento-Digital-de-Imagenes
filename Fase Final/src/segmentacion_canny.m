function edges = segmentacion_canny(path)

% Lectura de imagen
Img = imread(path);

I = double(Img);
I = I(:, :, 1); % canal gris


sigma = 10;

gaussiano = filtroGaussEspacio(sigma);
G = imfilter(I, gaussiano, 'replicate', 'conv');

[M, N] = size(G);

% Gradiente (Sobel)
x_masc = [-1 -2 -1; 0 0 0; 1 2 1];
y_masc = [-1 0 1; -2 0 2; -1 0 1];

df_dx = imfilter(G, x_masc, 'replicate', 'conv');
df_dy = imfilter(G, y_masc, 'replicate', 'conv');

% Magnitud
df = sqrt(df_dx.^2 + df_dy.^2);

% Dirección
dir = atan2(df_dy, df_dx);

% Dirección cuantizada de borde
d_borde = direccion_borde_2(dir);

% Supresión de no máximos
g_N = supresion_maximos(df, d_borde);

% salida final
edges = g_N;

end


function g_N = supresion_maximos(M_k, d_borde)
[M, N] = size(d_borde);

g_N = zeros(M, N);

M_k = padarray(M_k, [1 1], 'replicate');

for i = 2:M
    for j = 2:N
        
        Mk = M_k(i, j);
        
        dir = d_borde(i, j);
        
        vecinos = M_k(i-1:i+1, j-1:j+1);
        
        if dir == 0
            p = vecinos(2, 1);
            q = vecinos(2, 3);
        elseif dir == 90
            p = vecinos(1, 2);
            q = vecinos(3, 2);
        elseif dir == 45
            p = vecinos(1, 3);
            q = vecinos(3, 1);
        elseif dir == -45
            p = vecinos(1, 1);
            q = vecinos(3, 3);
        end
        
        if Mk < p || Mk < q
            g_N(i-1, j-1) = 0;
        else
            g_N(i-1, j-1) = Mk;
        end
        
    end
end


end


function d_borde = direccion_borde(d_k)

[M, N] = size(d_k);
d_borde = d_k+90;

d_borde = mod(d_borde, 180);

d_borde(d_borde == 135) = -45;

end

function d_k = direccion_borde_2(dir)

dir = rad2deg(dir);

pertenece = @(min, max) (dir >= min & dir < max);

d_k = zeros(size(dir)); % 0 por defecto

d_k( pertenece(-22.5, 22.5)  | pertenece(-157.5, 157.5)) = 0;
d_k( pertenece(22.5, 67.5)   | pertenece(-157.5, -112.5)) = 45;
d_k( pertenece(67.5, 112.5)  | pertenece(-112.5, -67.5))  = 90;
d_k( pertenece(112.5, 157.5) | pertenece(-67.5, -22.5))   = -45;

end

function [g_NH, g_NL] = histeresis_umbral(g_N, T_H, T_L)

[M, N] = size(g_N);

g_NH = g_N;
g_NL = g_N;

g_NH(g_NH < T_H) = 0;

g_NL(g_NL < T_L) = 0;

g_NL = g_NL - g_NH;


end






function C = cruces(L)
[M, N] = size(L);

d = 1;
L2 = padarray(L, [d d], 'replicate');

C = zeros(M, N);

for i = 2:M-1
    for j = 2:N-1
        
        p = L2(i, j);
        
        q = L2(i-1:i+1, j-1:j+1);
        
        q = q(:);
        %q = [q(1:4), q(6:9)];
        
        pq =  p*q < 0;
        pq = pq(:);
        
        pq = sum(pq(:));
        
        C(i-1, j-1) = pq > 0;
        
    end
end
end



function G = filtroGaussEspacio(sigma)
% Gaussiano PasaBajas en el dominio del espacio


n = ceil(6*sigma);

if(mod(n, 2) == 0)
    n = n + 1;
end

G = zeros(n);


% Para ubicar el centro de la máscara
cx = ceil(n/2);
cy = ceil(n/2);

disp(n);
disp(cx);
disp(cy);

for x = 1:n
    for y = 1:n
        d = ((x-cx)^2 + (y-cy)^2);
        
        z = d/(2*sigma^2);
        
        G(x, y) = exp(-z);
    end
end

end















