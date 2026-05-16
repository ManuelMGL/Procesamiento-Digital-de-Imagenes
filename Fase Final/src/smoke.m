function smoke(path)

% 0. Parámetros
clip = 0.02;
sigma = 4;          % Suavizado moderado para resaltar la textura del humo
K = 6;              % Número de clústeres para segmentación
radius = 1;         % Parámetro LBP
neighbors = 8;      % Parámetro LBP
T_smoke = 0.30;     % Umbral de distancia Chi-cuadrado

% 1. Leer imagen y convertir a Lab
I = imread(path);
lab = rgb2lab(I);
L = lab(:,:,1); 
A = lab(:,:,2); 
B = lab(:,:,3);

% 2. Preprocesamiento (Realce de textura)
% CLAHE ayuda a que el LBP "vea" mejor las variaciones del humo
Lc = adapthisteq(L/100, 'ClipLimit', clip);
Ls = imgaussfilt(Lc, sigma);

% 3. Segmentación por Color (K-means)
% Normalizamos canales para agrupar colores similares
X = reshape(cat(3, L/100, mat2gray(A), mat2gray(B)), [], 3);
[idx, ~] = kmeans(X, K, 'Replicates', 3, 'MaxIter', 200);
labels = reshape(idx, size(L));

% 4. Selección del Candidato a Humo (Basado en Color Gris)
% El humo suele ser neutro (A y B cerca de 0) y brillo medio-alto
meanL = zeros(K,1);
chroma = zeros(K,1);

for i = 1:K
    mask = (labels == i);
    meanL(i) = mean(L(mask));
    % Cromaticidad: qué tan lejos está del gris neutro
    chroma(i) = sqrt(mean(A(mask))^2 + mean(B(mask))^2);
end

% Score: buscamos alta luminancia y baja cromaticidad (gris)
score_humo = meanL .* (100 - chroma); 
[~, smokeCluster] = max(score_humo);
mask_candidato = (labels == smokeCluster);

% 5. Validación por Textura LBP
% Extraemos LBP solo de la región candidata
L_reg = Ls .* mask_candidato;
lbp_feat = extractLBPFeatures(L_reg, 'Radius', radius, 'NumNeighbors', neighbors);

% Normalizar histograma
Hlbp = histcounts(lbp_feat, 256) / (sum(histcounts(lbp_feat, 256)) + eps);

% 6. Comparación con Patrón y Decisión
load('Hsmoke.mat'); % Carga la variable 'Hsmoke' pre-entrenada
chi2 = 0.5 * sum(((Hlbp - Hsmoke).^2) ./ (Hlbp + Hsmoke + eps));

if chi2 < T_smoke
    resultado = 'HUMO CONFIRMADO';
else
    resultado = 'DESCARTADO (Textura no coincide)';
end

%% 7. Visualización
figure('Name', 'Detección de Humo LBP');

% Overlay: Pintamos el humo detectado en color Cian
overlay = im2double(I);
overlay(:,:,1) = overlay(:,:,1) .* ~mask_candidato; % Quitar rojo
overlay(:,:,2) = overlay(:,:,2) + mask_candidato * 0.4;
overlay(:,:,3) = overlay(:,:,3) + mask_candidato * 0.6;
overlay(overlay > 1) = 1;

subplot(1,2,1); imshow(I); title('Original');
subplot(1,2,2); imshow(overlay); 
title({resultado, ['\chi^2 = ', num2str(chi2)]});

end