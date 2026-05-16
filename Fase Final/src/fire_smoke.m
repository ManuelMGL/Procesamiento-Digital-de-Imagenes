function fire_smoke(path)

clc;
close all;


% 1. PARÁMETROS

K = 8;

sigma_gauss = 15;

clip_limit = 0.01;


% 2. LECTURA

I = imread(path);

I_double = im2double(I);


% 3. PREPROCESAMIENTO


%  REDUCCIÓN DE RUIDO (GAUSSIANO)
I_gauss = imgaussfilt( ...
    I_double, ...
    sigma_gauss);

%  RGB -> LAB
lab = rgb2lab(I_gauss);

L = lab(:,:,1);

A = lab(:,:,2);

B = lab(:,:,3);

%  NORMALIZACIÓN L*
L_norm = L / 100;

%  CLAHE SOBRE L*
L_eq = adapthisteq( ...
    L_norm, ...
    'ClipLimit', clip_limit, ...
    'NumTiles', [8 8]);

%  RECONSTRUCCIÓN LAB
lab_eq = cat(3, ...
    L_eq * 100, ...
    A, ...
    B);


% 4. EXTRACCIÓN DE TEXTURA

E = entropyfilt(uint8(L_eq * 255));

E_norm = mat2gray(E);


% 5. K-MEANS (LAB + TEXTURA)


% normalización LAB
Lk = lab_eq(:,:,1) / 100;

Ak = lab_eq(:,:,2) / 128;

Bk = lab_eq(:,:,3) / 128;

% vector de características
X = [ ...
    Lk(:), ...
    Ak(:), ...
    Bk(:), ...
    E_norm(:)];

[idx,~] = kmeans( ...
    X, ...
    K, ...
    'Replicates', 3, ...
    'MaxIter', 200);

labels = reshape(idx, size(L));


% 6. MÁSCARAS

mask_fire  = false(size(L));

mask_smoke = false(size(L));


% 7. CLASIFICACIÓN POR REGIÓN

for i = 1:K
    
    region = (labels == i);
    
    % filtro de tamaño
    if nnz(region) < 150
        continue;
    end
    
    % regiones LAB
    Lr = Lk(region);
    
    Ar = Ak(region);
    
    Br = Bk(region);
    
    Er = E_norm(region);
    
    
    % 🔥 DETECCIÓN DE FUEGO
    
    fire_score = ...
        mean(Ar) ...
        + mean(Br) ...
        + 0.5 * mean(Lr);
    
    if fire_score > 0.6 && mean(Ar) > 0
        
        mask_fire(region) = true;
        
        continue;
        
    end
    
    
    % DETECCIÓN DE HUMO
    
    
    % luminancia
    lum = mean(Lr);
    
    % saturación
    sat = mean( ...
        sqrt(Ar.^2 + Br.^2));
    
    % entropía
    ent = mean(Er);
    
    % desviación estándar
    dev = std(Lr);
    
    % reglas humo
    if lum > 0.4 && ...
            lum < 0.9 && ...
            sat < 0.12 && ...
            dev > 0.015 && ...
            ent > 0.3
        
        mask_smoke(region) = true;
        
    end
end


% 8. POSTPROCESAMIENTO MORFOLÓGICO

se = strel('disk', 2);

mask_fire = imopen(mask_fire, se);

mask_smoke = imopen(mask_smoke, se);


% 9. OVERLAY FINAL

overlay = I_double;

% 🔥 fuego rojo
overlay(:,:,1) = ...
    overlay(:,:,1) + mask_fire * 0.7;

overlay(:,:,2) = ...
    overlay(:,:,2) .* ~mask_fire;

overlay(:,:,3) = ...
    overlay(:,:,3) .* ~mask_fire;

% 🌫 humo cyan
overlay(:,:,1) = ...
    overlay(:,:,1) .* ~mask_smoke;

overlay(:,:,2) = ...
    overlay(:,:,2) + mask_smoke * 0.5;

overlay(:,:,3) = ...
    overlay(:,:,3) + mask_smoke * 0.5;

overlay(overlay > 1) = 1;


% 10. VISUALIZACIÓN

figure( ...
    'Name', ...
    'Detección Avanzada de Incendios');


% PREPROCESAMIENTO

subplot(3,4,1);

imshow(I);

title('Imagen original');

subplot(3,4,2);

imshow(I_gauss);

title(sprintf( ...
    'Filtro Gaussiano | \\sigma = %.2f', ...
    sigma_gauss));

subplot(3,4,3);

imshow(L_norm,[]);

title('L* original');

subplot(3,4,4);

imshow(L_eq,[]);

title(sprintf( ...
    'CLAHE sobre L* | Clip = %.3f', ...
    clip_limit));


% HISTOGRAMAS

subplot(3,4,5);

imhist(L_norm);

title('Histograma L* original');

subplot(3,4,6);

imhist(L_eq);

title('Histograma CLAHE');

subplot(3,4,7);

plot( ...
    L_norm(1:500:end), ...
    L_eq(1:500:end), '.');

grid on;

title('Distribución L*');

xlabel('Original');

ylabel('CLAHE');

subplot(3,4,8);

imshow(E_norm,[]);

title('Mapa de textura');


% SEGMENTACIÓN

subplot(3,4,9);

imshow(label2rgb(labels));

title(sprintf( ...
    'K-means LAB + textura | K = %d', ...
    K));

subplot(3,4,10);

imshow(mask_fire);

title('Máscara fuego');

subplot(3,4,11);

imshow(mask_smoke);

title('Máscara humo');


% RESULTADO FINAL

subplot(3,4,12);

imshow(overlay);

title('Resultado final');

end