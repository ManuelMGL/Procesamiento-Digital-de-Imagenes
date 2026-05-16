function fire(path)

clc;
close all;

%% =========================================================
% 0. PARÁMETROS
%% =========================================================

clip = 0.02;
sigma = 5;
median_size = [3 3];
alpha = 0.2;
K = 4;

radius = 1;
neighbors = 8;
T_fire = 0.25;

%% =========================================================
% 1. LEER IMAGEN
%% =========================================================
I = imread(path);
I_double = im2double(I);

%% =========================================================
% 2. PREPROCESAMIENTO
%% =========================================================

I_med = medfilt3(I);
I_gauss = imgaussfilt(I_med, sigma);

%% =========================================================
% 3. RGB -> LAB
%% =========================================================
lab = rgb2lab(I_gauss);

L = lab(:,:,1);
A = lab(:,:,2);
B = lab(:,:,3);

%% =========================================================
% 4. CLAHE EN L*
%% =========================================================
L_norm = L / 100;

Lc = adapthisteq(L_norm, ...
    'ClipLimit', clip, ...
    'NumTiles', [8 8]);

%% =========================================================
% 5. FILTRADO POST-CLAHE
%% =========================================================
Ls = imgaussfilt(Lc, sigma);

%% =========================================================
% 6. REALCE DE BORDES
%% =========================================================
G = imgradient(Ls);

H = fspecial('laplacian', alpha);
Lap = imfilter(Ls, H);

GL = mat2gray(G + Lap);

%% =========================================================
% 7. K-MEANS EN LAB
%% =========================================================
L2 = L / 100;
A2 = A / 128;
B2 = B / 128;

X = reshape(cat(3, L2, A2, B2), [], 3);

[idx, ~] = kmeans(X, K, ...
    'Distance', 'sqeuclidean', ...
    'Replicates', 10, ...
    'MaxIter', 300, ...
    'Start', 'plus');

labels = reshape(idx, size(L));

%% =========================================================
% 8. SELECCIÓN CLUSTER FUEGO
%% =========================================================
meanL = zeros(K,1);
meanA = zeros(K,1);
meanB = zeros(K,1);

for i = 1:K
    mask = (labels == i);
    meanL(i) = mean(L2(mask));
    meanA(i) = mean(A2(mask));
    meanB(i) = mean(B2(mask));
end

score = meanA + meanB + 0.5 * meanL;

[~, fireCluster] = max(score);

mask_fire = labels == fireCluster;

%% =========================================================
% 9. LIMPIEZA MORFOLÓGICA
%% =========================================================
se = strel('disk',2);

mask_fire = imopen(mask_fire, se);
mask_fire = imclose(mask_fire, se);
mask_fire = bwareaopen(mask_fire, 100);

%% =========================================================
% 10. REGIÓN DE FUEGO
%% =========================================================
L_fire = Ls .* mask_fire;

%% =========================================================
% 11. LBP
%% =========================================================
lbp = extractLBPFeatures(L_fire, ...
    'Radius', radius, ...
    'NumNeighbors', neighbors);

Hlbp = histcounts(lbp, 256);
Hlbp = Hlbp / (sum(Hlbp) + eps);

%% =========================================================
% 12. PATRÓN DE REFERENCIA
%% =========================================================
load('Hfire.mat'); % Hfire

%% =========================================================
% 13. CHI²
%% =========================================================
chi2 = 0.5 * sum(((Hlbp - Hfire).^2) ./ (Hlbp + Hfire + eps));

%% =========================================================
% 14. DECISIÓN
%% =========================================================
if chi2 < T_fire
    resultado = 'FUEGO DETECTADO';
else
    resultado = 'NO FUEGO';
end

%% =========================================================
% 15. VISUALIZACIÓN ÚNICA
%% =========================================================
figure('Name','Pipeline de detección de fuego','NumberTitle','off');

subplot(3,4,1); imshow(I); title('RGB original');
subplot(3,4,2); imshow(I_med); title('Mediana');
subplot(3,4,3); imshow(I_gauss); title('Gaussiano');

subplot(3,4,4); imshow(L_norm,[]); title('L* normalizado');
subplot(3,4,5); imshow(Lc,[]); title('CLAHE');
subplot(3,4,6); imhist(Lc); title('Histograma CLAHE');

subplot(3,4,7); imshow(Ls,[]); title('L* suavizado');
subplot(3,4,8); imshow(G,[]); title('Gradiente');
subplot(3,4,9); imshow(GL,[]); title('Gradiente + Laplaciano');

subplot(3,4,10); imshow(label2rgb(labels)); title(sprintf('K-means K=%d',K));
subplot(3,4,11); imshow(mask_fire); title(sprintf('Cluster fuego %d',fireCluster));

% subplot(3,4,12);
% plot(Hlbp,'LineWidth',1.2); grid on;
% title('LBP histograma'); xlabel('Bins'); ylabel('Freq');

overlay = I_double;

overlay(:,:,1) = overlay(:,:,1) + mask_fire * 0.8;
overlay(:,:,2) = overlay(:,:,2) .* ~mask_fire;
overlay(:,:,3) = overlay(:,:,3) .* ~mask_fire;

overlay(overlay > 1) = 1;

subplot(3,4,12);
imshow(overlay, []);
title("Resultado");

% subplot(4,4,14); axis off;
% subplot(4,4,15); axis off;
% subplot(4,4,16); axis off;

end