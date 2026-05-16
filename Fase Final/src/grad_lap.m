function G = grad_lap(img_in)
% Filtrado Gradiente-Laplaciano
% Pasos
% 1) R(x,y) = f(x,y) + c[∇²f(x,y)]
% 2) Mag(∇f)
% 3) Mag(∇f) suavizada
% 4) Mask(x,y) = R(x,y) × Mag(∇f) suavizada
% 5) g(x,y) = f(x,y) + Mask(x,y)
% 6) Corrección Gamma

    f = double(img_in);

    % ── PASO 1: Imagen realzada con Laplaciano 
    w_lap = [0  1  0;
             1 -4  1;
             0  1  0];

    c = -1;                                    % constante c del paso 1
    L = imfilter(f, w_lap, 'replicate');       % ∇²f(x,y)
    R = f + c * L;                             % R(x,y) = f + c·∇²f

    % ── PASO 2: Magnitud del gradiente 
    Gx = [-1  0  1;
          -2  0  2;
          -1  0  1];  

    Gy = [-1 -2 -1;
           0  0  0;
           1  2  1];  

    mag_grad = abs(imfilter(f, Gx, 'replicate')) + ...
               abs(imfilter(f, Gy, 'replicate'));

    % ── PASO 3: Suavizar la magnitud del gradiente
    w_avg      = fspecial('average', [5 5]);
    mag_smooth = imfilter(mag_grad, w_avg, 'replicate');  % Mag(∇f) ‾

    % PASO 4: Máscara 
    % Normalizar el gradiente suavizado a [0,1] antes de multiplicar
    mag_norm = mag_smooth / max(mag_smooth(:));
    Mask     = R .* mag_norm;                  % Mask = R × Mag(∇f)‾

    %PASO 5: Sumar máscara a la imagen original 
    g = f + Mask;                              % g(x,y) = f + Mask

    % PASO 6: Corrección Gamma

    gamma   = 0.6;
    g       = max(0, g);
    g_norm  = g / max(g(:));
    g_gamma = g_norm .^ gamma;
    G       = uint8(g_gamma * 255);
end