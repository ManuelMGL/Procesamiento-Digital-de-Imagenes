function [I_binaria, T] = otsuUmbral1(img_gray)
% [I_binaria, T] = otsuUmbral1(img_gray)
% Umbralizacion de Otsu con UN umbral - implementacion manual
%
% img_gray  : imagen en escala de grises (uint8)
% I_binaria : imagen binaria (1=objeto, 0=fondo)
% T         : umbral optimo (0-255)
%
% Criterio: maximizar la varianza inter-clase
%           sigma_B(T) = w0 * w1 * (mu0 - mu1)^2

    img = double(img_gray);
    N   = numel(img);

    counts = histcounts(img(:), 0:256);
    p      = counts / N;
    mu_T   = sum((0:255) .* p);

    sigma_max = -Inf;
    T_opt     = 0;
    w0        = 0;
    mu0       = 0;

    for k = 0:254
        w0  = w0  + p(k+1);
        mu0 = mu0 + k * p(k+1);
        w1  = 1 - w0;

        if w0 == 0 || w1 == 0
            continue
        end

        mu1     = (mu_T - mu0) / w1;
        sigma_b = w0 * w1 * (mu0/w0 - mu1)^2;

        if sigma_b > sigma_max
            sigma_max = sigma_b;
            T_opt     = k;
        end
    end

    T         = T_opt;
    I_binaria = img_gray > T;
end
