% =========================================================
% PIPELINE COMPLETO - TODAS LAS TÉCNICAS
% Adrián Chacón - Forest Fire Dataset - Fase Final PDI
% =========================================================
clc; clear all; close all force;

% =========================================================
% RUTAS
% =========================================================

path = "../examples/original/";
path_roi = "../examples/roi/";
out_path = "../examples/augmented/";


if ~exist(out_path, 'dir'), mkdir(out_path); end

% =========================================================
% IMÁGENES
% =========================================================
nombres = [
    %"1564_jpg.rf.a033c9a020b5b3559ac187a36aa150ea.jpg"
    "10_png.rf.2bb4801aa63a6070814528d2d7fed3a2.jpg"
    "34_png.rf.43358fb7435b8fbde8cfa1461cf951af.jpg"
    %"594_png.rf.26e2489111e0488fdbe709c4c288e78b.jpg"
    %"1601_jpg.rf.facb1cf8b55849155bf7fbded5bed7fa.jpg"
    "60_png.rf.02ba237d0a88e494a6f81cf2f87a1848.jpg"
    %"3_JPG.rf.48889bb592371a826b2ceb2c06d48a69.jpg"
    %"486_png.rf.39965f90caeaaa73f4c37c5f554bdc66.jpg"
    %"124_png.rf.d2359abf71e430062468dfdf49dd7fa7.jpg"
    "80_png.rf.9a497708ef1f4dc06cb634f47d49255b.jpg"
    ];

clases = [
    %"humo_fuego"
    %"humo_fuego"
    %"humo_fuego"
    %"humo_fuego"
    "fuego"
    "fuego"
    "fuego"
    %"humo_fuego"
    %"humo_fuego"
    "fuego"
    ];
% =========================================================
% PARÁMETROS
% =========================================================
params_humo.clip   = 300;
params_humo.K      = 5;
params_humo.k_hb   = 2.0;
params_humo.clip_label = 'CLAHE(300)+GradLap';

params_hf.clip     = 200;
params_hf.K        = 5;
params_hf.k_hb     = 2.0;
params_hf.clip_label = 'CLAHE(200)+HB(k=2.0)';

% Imágenes que NO usan Grad-Lap (pavimento domina)
imgs_sin_gradlap = [7];

categorias = ["fuego", "humo", "vegetacion"];

% =========================================================
% LOOP PRINCIPAL
% =========================================================
for i = 1:numel(nombres)

    full_path  = path + nombres(i);
    clase      = clases(i);
    [~, nb, ~] = fileparts(nombres(i));

    img_color = imread(full_path);
    img_gray  = im2gray(img_color);

    fprintf('\n[%d/%d] %s — %s\n', i, numel(nombres), nb, clase);

    if clase == "humo"
        p = params_humo;
    else
        p = params_hf;
    end

    % ======================================================
    % FIGURA 1: PREPROCESAMIENTO COMPLETO
    % Muestra TODAS las técnicas requeridas por la asignación
    % ======================================================

    % --- Aplicar cada técnica ---
    img_eq    = ecualizar(img_gray);                          % i. Ecualización

    img_eq2   = ecualizar(img_gray);
    [~, T_cl] = cliplim(img_eq2, p.clip);
    img_clahe = interpola_tile(img_gray, T_cl, T_cl, T_cl, T_cl); % ii. CLAHE

    img_hb    = highboost(img_gray, p.k_hb);                  % iii. Highboost

    img_gl    = grad_lap(img_gray);                           % iv. Grad-Laplaciano

    img_alf   = adaptive_filter(img_gray, 5, 1);              % v. Filtro Adaptativo Local
    img_alf   = uint8(img_alf);

    img_amf   = adaptive_filter_median(img_gray, 7);          % vi. Filtro Mediano Adaptativo
    img_amf   = uint8(img_amf);

    fig1 = figure('Name', sprintf('[%d] Preprocesamiento - %s', i, clase), ...
                  'NumberTitle','off','Position',[10 10 1400 600]);

    subplot(2,4,1); imshow(img_color);        title('Original color')
    subplot(2,4,2); imshow(img_gray,[]);      title('Escala de grises')
    subplot(2,4,3); imshow(img_eq,[]);        title('i. Ecualización histograma')
    subplot(2,4,4); imshow(img_clahe,[]);     title(sprintf('ii. CLAHE (clip=%d)', p.clip))
    subplot(2,4,5); imshow(img_hb,[]);        title(sprintf('iii. Highboost (k=%.1f)', p.k_hb))
    subplot(2,4,6); imshow(img_gl,[]);        title('iv. Gradiente-Laplaciano')
    subplot(2,4,7); imshow(img_alf,[]);       title('v. Filtro Adaptativo Local')
    subplot(2,4,8); imshow(img_amf,[]);       title('vi. Filtro Mediano Adaptativo')

    exportgraphics(fig1, fullfile(out_path, nb+"_1_preprocesamiento.png"), 'Resolution',150)

    % ======================================================
    % FIGURA 2: TRANSFORMACIÓN DE COLOR
    % ======================================================
    img_hsv  = rgb2hsv(img_color);
    img_lab  = rgb2lab(img_color);
    img_ycbcr= rgb2ycbcr(img_color);

    fig2 = figure('Name', sprintf('[%d] Modelos de Color - %s', i, clase), ...
                  'NumberTitle','off','Position',[10 10 1400 500]);

    subplot(2,4,1); imshow(img_color);                    title('RGB original')
    subplot(2,4,2); imshow(img_hsv(:,:,1),[]);            title('HSV - Canal H (matiz)')
    subplot(2,4,3); imshow(img_hsv(:,:,2),[]);            title('HSV - Canal S (saturación)')
    subplot(2,4,4); imshow(img_hsv(:,:,3),[]);            title('HSV - Canal V (valor)')
    subplot(2,4,5); imshow(img_lab(:,:,1),[]);            title('LAB - Canal L (luminosidad)')
    subplot(2,4,6); imshow(img_lab(:,:,2),[]);            title('LAB - Canal a (verde-rojo)')
    subplot(2,4,7); imshow(img_lab(:,:,3),[]);            title('LAB - Canal b (azul-amarillo)')
    subplot(2,4,8); imshow(img_ycbcr(:,:,1),[]);         title('YCbCr - Canal Y')

    exportgraphics(fig2, fullfile(out_path, nb+"_2_colores.png"), 'Resolution',150)

    % ======================================================
    % PREPROCESAMIENTO ÓPTIMO PARA SEGMENTACIÓN
    % ======================================================
    if clase == "humo" && ~ismember(i, imgs_sin_gradlap)
        img_pre   = grad_lap(img_clahe);
        pre_label = sprintf('CLAHE(%d)+GradLap', p.clip);
    elseif ismember(i, imgs_sin_gradlap)
        img_pre   = img_clahe;
        pre_label = sprintf('CLAHE(%d) solo', p.clip);
    else
        img_pre   = highboost(img_clahe, p.k_hb);
        pre_label = sprintf('CLAHE(%d)+HB(k=%.1f)', p.clip, p.k_hb);
    end

    % ======================================================
    % FIGURA 3: SEGMENTACIÓN COMPLETA
    % ======================================================
    [I_otsu1, T1]        = otsuUmbral1(img_pre);
    [I_otsu2, T2]        = otsuUmbral2(img_pre);
    edges                = segmentacion_canny(full_path);
    labels_rgb           = k_means_rgb(full_path, p.K);
    labels_lab           = kmeans_lab(full_path, p.K);

    try
        [I_lbp, mapa, dists] = segmentarLBP(img_gray, path_roi, categorias, 8);
        lbp_ok = true;
    catch
        I_lbp = zeros(size(img_gray),'uint8');
        mapa  = zeros(floor(size(img_gray,1)/8), floor(size(img_gray,2)/8));
        dists = [0 0 0];
        lbp_ok = false;
    end

    fig3 = figure('Name', sprintf('[%d] Segmentación - %s', i, clase), ...
                  'NumberTitle','off','Position',[30 30 1400 700]);

    subplot(2,4,1); imshow(img_color);         title(sprintf('Original (%d)', i))
    subplot(2,4,2); imshow(img_pre,[]);        title(pre_label)
    subplot(2,4,3); imshow(I_otsu1,[]);        title(sprintf('Otsu 1  T=%d', T1))
    subplot(2,4,4); imshow(I_otsu2,[]);        title(sprintf('Otsu 2  T1=%d T2=%d', T2(1),T2(2)))

    subplot(2,4,5)
    imagesc(labels_lab); axis image off
    colormap(gca, lines(p.K))
    title(sprintf('K-Means LAB  K=%d', p.K))

    subplot(2,4,6)
    if lbp_ok
        imagesc(mapa); axis image off
        colormap(gca,[0.25 0.25 0.25; 1 0.35 0.05; 0.55 0.55 0.55; 0.15 0.65 0.15])
        colorbar('Ticks',[0.375 1.125 1.875 2.625], ...
                 'TickLabels',{'Descon.','Fuego','Humo','Vegetac.'})
        title('LBP - Mapa texturas (bloque=16)')
    else
        imshow(I_lbp,[]); title('LBP (sin ROI)')
    end

    subplot(2,4,7)
    imhist(img_gray); hold on
    xline(T1,    '-r',  ['T='  num2str(T1)],    'LineWidth',2,'LabelVerticalAlignment','bottom')
    xline(T2(1), '--b', ['T1=' num2str(T2(1))], 'LineWidth',2,'LabelVerticalAlignment','bottom')
    xline(T2(2), '--m', ['T2=' num2str(T2(2))], 'LineWidth',2,'LabelVerticalAlignment','bottom')
    hold off
    legend('Histograma','Otsu-1','Otsu-2a','Otsu-2b','Location','best')
    title('Histograma + Umbrales Otsu')

    subplot(2,4,8)
    bar(dists,'FaceColor',[0.2 0.5 0.8])
    set(gca,'XTickLabel',{'Fuego','Humo','Vegetac.'},'XTick',1:3)
    ylabel('Chi-cuadrado'); title('Similitud LBP')

    exportgraphics(fig3, fullfile(out_path, nb+"_3_segmentacion.png"), 'Resolution',150)

    % ======================================================
    % FIGURA 4: CANNY + K-Means RGB vs LAB
    % ======================================================
    fig4 = figure('Name', sprintf('[%d] Extra - %s', i, clase), ...
                  'NumberTitle','off','Position',[80 80 1100 380]);

    subplot(1,3,1); imshow(edges,[]); title('Canny')

    subplot(1,3,2)
    imagesc(labels_rgb); axis image off
    colormap(gca, lines(p.K))
    title(sprintf('K-Means RGB  K=%d', p.K))

    subplot(1,3,3)
    imagesc(labels_lab); axis image off
    colormap(gca, lines(p.K))
    title(sprintf('K-Means LAB  K=%d', p.K))

    exportgraphics(fig4, fullfile(out_path, nb+"_4_extra.png"), 'Resolution',150)

    % ======================================================
    % GUARDAR RESULTADOS INDIVIDUALES
    % ======================================================
    imwrite(img_eq,              fullfile(out_path, nb+"_pre_ecualizacion.png"))
    imwrite(img_clahe,           fullfile(out_path, nb+"_pre_clahe.png"))
    imwrite(img_hb,              fullfile(out_path, nb+"_pre_highboost.png"))
    imwrite(img_gl,              fullfile(out_path, nb+"_pre_gradlap.png"))
    imwrite(img_alf,             fullfile(out_path, nb+"_pre_alf.png"))
    imwrite(img_amf,             fullfile(out_path, nb+"_pre_amf.png"))
    imwrite(uint8(I_otsu1)*255,  fullfile(out_path, nb+"_seg_otsu1.png"))
    imwrite(I_otsu2,             fullfile(out_path, nb+"_seg_otsu2.png"))
    imwrite(I_lbp,               fullfile(out_path, nb+"_seg_lbp.png"))
    imwrite(img_gray,            fullfile(out_path, nb+"_grises.png"))

    fprintf('  T1=%d  T2=[%d,%d]  Chi=[%.3f %.3f %.3f]\n', ...
        T1, T2(1), T2(2), dists(1), dists(2), dists(3))

end

fprintf('\n=== Listo. 4 figuras por imagen guardadas en:\n%s\n', out_path)