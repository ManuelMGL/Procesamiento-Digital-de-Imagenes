function [I_multiclas, T] = otsuUmbral2(img_gray)
% [I_multiclas, T] = otsuUmbral2(img_gray)
% Umbralizacion de Otsu con DOS umbrales (3 clases) - implementacion manual
%
% img_gray    : imagen en escala de grises (uint8)
% I_multiclas : imagen con niveles 0 (fondo) / 128 (medio) / 255 (primer plano)
% T           : vector [T1, T2] con los umbrales optimos (T1 < T2)
%
% Criterio: maximizar la varianza inter-clase con 3 clases
%           sigma_B = w0*(mu0-muT)^2 + w1*(mu1-muT)^2 + w2*(mu2-muT)^2

    img = double(img_gray);
    N   = numel(img);

    counts = histcounts(img(:), 0:256);
    p      = counts / N;
    k      = 0:255;

    P    = cumsum(p);
    MU   = cumsum(k .* p);
    mu_T = MU(256);

    sigma_max = -Inf;
    T1_opt    = 0;
    T2_opt    = 1;

    for t1 = 0:253
        for t2 = (t1+1):254

            w0 = P(t1+1);
            if w0 == 0, continue, end
            mu0 = MU(t1+1) / w0;

            w1 = P(t2+1) - P(t1+1);
            if w1 == 0, continue, end
            mu1 = (MU(t2+1) - MU(t1+1)) / w1;

            w2 = 1 - P(t2+1);
            if w2 == 0, continue, end
            mu2 = (mu_T - MU(t2+1)) / w2;

            sigma_b = w0*(mu0-mu_T)^2 + w1*(mu1-mu_T)^2 + w2*(mu2-mu_T)^2;

            if sigma_b > sigma_max
                sigma_max = sigma_b;
                T1_opt    = t1;
                T2_opt    = t2;
            end
        end
    end

    T = [T1_opt, T2_opt];

    I_multiclas                  = zeros(size(img_gray), 'uint8');
    I_multiclas(img_gray > T(1)) = 128;
    I_multiclas(img_gray > T(2)) = 255;
end
