function [I_lbp, mapa_labels, dists] = segmentarLBP(img_gray, path_roi, categorias, tam_bloque)
% [I_lbp, mapa_labels, dists] = segmentarLBP(img_gray, path_roi, categorias, tam_bloque)
% Segmenta una imagen usando LBP y firmas de referencia
%
% img_gray    : imagen en escala de grises (uint8)
% path_roi    : carpeta raiz con subcarpetas por categoria
% categorias  : string array ej: ["fuego", "humo", "vegetacion"]
% tam_bloque  : tamanio del bloque en pixeles (recomendado: 32)
%
% I_lbp       : imagen LBP completa (uint8, valores 0-255)
% mapa_labels : matriz de etiquetas por bloque
%               0=desconocido, 1=cat1, 2=cat2, 3=cat3...
% dists       : distancias Chi-cuadrado del LBP global vs cada firma
%
% Umbral de rechazo: si la distancia minima > UMBRAL_MAX el bloque
% se etiqueta como 0 (desconocido)

    UMBRAL_MAX = 1.5;

    % Cargar firmas LBP de referencia
    firmas = cargarFirmas(path_roi, categorias);

    % Imagen LBP completa
    I_lbp = lbp(img_gray);

    % Distancias Chi-cuadrado del LBP global
    h_global = histNorm(I_lbp);
    dists    = zeros(1, numel(firmas));
    for f = 1:numel(firmas)
        dists(f) = chiCuadrado(h_global, firmas(f).histograma);
    end

    % Segmentacion por bloques
    [rows, cols] = size(img_gray);
    n_rows       = floor(rows / tam_bloque);
    n_cols       = floor(cols / tam_bloque);
    mapa_labels  = zeros(n_rows, n_cols, 'uint8');

    for br = 1:n_rows
        for bc = 1:n_cols

            r_ini = (br-1)*tam_bloque + 1;
            r_fin = r_ini + tam_bloque - 1;
            c_ini = (bc-1)*tam_bloque + 1;
            c_fin = c_ini + tam_bloque - 1;

            h_bloque = histNorm(I_lbp(r_ini:r_fin, c_ini:c_fin));

            d_bloque = zeros(1, numel(firmas));
            for f = 1:numel(firmas)
                d_bloque(f) = chiCuadrado(h_bloque, firmas(f).histograma);
            end

            [d_min, idx_min] = min(d_bloque);

            if d_min <= UMBRAL_MAX
                mapa_labels(br, bc) = idx_min;
            else
                mapa_labels(br, bc) = 0;
            end
        end
    end
end


% ---- Funciones locales -----------------------------------------------

function img_lbp = lbp(img)
% Calcula la imagen LBP (8 vecinos, radio=1)
% Orden horario desde TL: TL T TR R BR B BL L
% Umbral = valor del pixel central, MSB = primer vecino

    [rows, cols] = size(img);
    img_lbp = zeros(rows, cols, 'uint8');
    imgP    = padarray(double(img), [1 1], 'replicate');

    dy = [-1 -1 -1  0  1  1  1  0];
    dx = [-1  0  1  1  1  0 -1 -1];

    for r = 1:rows
        for c = 1:cols
            centro = imgP(r+1, c+1);
            codigo = uint8(0);
            for k = 1:8
                v = imgP(r+1+dy(k), c+1+dx(k));
                if v >= centro
                    codigo = bitor(codigo, uint8(bitshift(uint8(1), 8-k)));
                end
            end
            img_lbp(r, c) = codigo;
        end
    end
end

% ---------------------------------------------------------------------

function h = histNorm(img_lbp)
% Histograma normalizado de 256 bins para una imagen LBP

    counts = histcounts(double(img_lbp(:)), 0:256);
    total  = sum(counts);
    if total > 0
        h = counts / total;
    else
        h = zeros(1, 256);
    end
end

% ---------------------------------------------------------------------

function d = chiCuadrado(H1, H2)
% Distancia Chi-Cuadrado entre dos histogramas normalizados
% d = sum( (H1_i - H2_i)^2 / (H1_i + H2_i) )

    suma = H1 + H2;
    mask = suma > 0;
    d    = sum( (H1(mask) - H2(mask)).^2 ./ suma(mask) );
end

% ---------------------------------------------------------------------

function firmas = cargarFirmas(path_roi, categorias)
% Carga recortes de cada subcarpeta y calcula la firma LBP promedio

    firmas(numel(categorias)) = struct('nombre', '', 'histograma', []);

    for i = 1:numel(categorias)

        carpeta  = fullfile(path_roi, categorias(i));
        archivos = [dir(fullfile(carpeta, '*.jpg')); ...
                    dir(fullfile(carpeta, '*.png'))];

        if isempty(archivos)
            warning('Sin imagenes en: %s', carpeta)
            firmas(i).nombre     = char(categorias(i));
            firmas(i).histograma = zeros(1, 256);
            continue
        end

        H_acum = zeros(1, 256);

        for j = 1:numel(archivos)
            img_c = imread(fullfile(archivos(j).folder, archivos(j).name));
            if size(img_c, 3) == 3
                img_g = im2gray(img_c);
            else
                img_g = img_c;
            end
            H_acum = H_acum + histNorm(lbp(img_g));
        end

        firmas(i).nombre     = char(categorias(i));
        firmas(i).histograma = H_acum / numel(archivos);

        fprintf('Firma "%s" cargada: %d imagenes.\n', firmas(i).nombre, numel(archivos))
    end
end
