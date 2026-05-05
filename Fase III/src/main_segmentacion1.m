% Segmentación de Imágenes - Forest Fire Dataset
% Tecnicas: Otsu 1 umbral, Otsu 2 umbrales, LBP
clc
clear all
close all force

nombres = [...
    "1_JPG.rf.82be351019b363a690c1f9394144c4d9.jpg" ...
    "2_png.rf.0120d97dddac35e037d18b09cf507edb.jpg" ...
    "32_png.rf.343001e4aa37d963fa0d9942c1192c7b.jpg" ...
    "10_png.rf.2bb4801aa63a6070814528d2d7fed3a2.jpg" ...
];

path     = "E:/UTM/MAESTRIA/PDI/Proyecto/Fase III - Aumento de Datos/examples/original/";
path_roi = "E:/UTM/MAESTRIA/PDI/Proyecto/Fase III - Aumento de Datos/examples/roi/";
out_path = "E:/UTM/MAESTRIA/PDI/Proyecto/Fase III - Aumento de Datos/examples/augmented/";

if ~exist(out_path, 'dir')
    mkdir(out_path)
end

I1 = im2gray(imread(path + nombres(1)));
I2 = im2gray(imread(path + nombres(2)));
I3 = im2gray(imread(path + nombres(3)));
I4 = im2gray(imread(path + nombres(4)));

I1c = imread(path + nombres(1));
I2c = imread(path + nombres(2));
I3c = imread(path + nombres(3));
I4c = imread(path + nombres(4));

I  = {I1,  I2,  I3,  I4};
Ic = {I1c, I2c, I3c, I4c};

categorias = ["fuego", "humo", "vegetacion"];

fprintf('%-5s %-10s %-10s %-10s %-12s %-12s %-12s\n', ...
    'Img', 'T_otsu1', 'T1_otsu2', 'T2_otsu2', 'Chi_fuego', 'Chi_humo', 'Chi_veg');
fprintf('%s\n', repmat('-', 1, 72));

for i = 1:4

    img_gray  = I{i};
    img_color = Ic{i};

    [I_otsu1, T1] = otsuUmbral1(img_gray);
    [I_otsu2, T2] = otsuUmbral2(img_gray);
    [I_lbp, mapa, dists] = segmentarLBP(img_gray, path_roi, categorias, 32);

    fprintf('%-5d %-10d %-10d %-10d %-12.4f %-12.4f %-12.4f\n', ...
        i, T1, T2(1), T2(2), dists(1), dists(2), dists(3));

    fig = figure('Name', ['Segmentacion - Imagen ' num2str(i)], ...
        'NumberTitle', 'off', 'Position', [30 30 1300 650]);

    subplot(2, 4, 1)
    imshow(img_color)
    title(['Original (' num2str(i) ')'])

    subplot(2, 4, 2)
    imshow(img_gray, [])
    title('Escala de grises')

    subplot(2, 4, 3)
    imshow(I_otsu1, [])
    title(['Otsu 1 umbral  T=' num2str(T1)])

    subplot(2, 4, 4)
    imshow(I_otsu2, [])
    title(['Otsu 2 umbrales  T1=' num2str(T2(1)) '  T2=' num2str(T2(2))])

    subplot(2, 4, 5)
    imagesc(mapa)
    axis image off
    colormap(gca, [0.25 0.25 0.25; 1 0.35 0.05; 0.55 0.55 0.55; 0.15 0.65 0.15])
    colorbar('Ticks', [0.375 1.125 1.875 2.625], ...
        'TickLabels', {'Descon.', 'Fuego', 'Humo', 'Vegetac.'})
    title('LBP - Mapa de texturas')

    subplot(2, 4, 6)
    imshow(I_lbp, [])
    title('Imagen LBP')

    subplot(2, 4, 7)
    imhist(img_gray)
    hold on
    xline(T1,    '-r',  ['T='  num2str(T1)],    'LineWidth', 2, 'LabelVerticalAlignment', 'bottom')
    xline(T2(1), '--b', ['T1=' num2str(T2(1))], 'LineWidth', 2, 'LabelVerticalAlignment', 'bottom')
    xline(T2(2), '--m', ['T2=' num2str(T2(2))], 'LineWidth', 2, 'LabelVerticalAlignment', 'bottom')
    hold off
    legend('Histograma', 'Otsu-1', 'Otsu-2a', 'Otsu-2b', 'Location', 'best')
    title('Histograma + Umbrales Otsu')

    subplot(2, 4, 8)
    bar(dists, 'FaceColor', [0.2 0.5 0.8])
    set(gca, 'XTickLabel', {'Fuego', 'Humo', 'Vegetac.'}, 'XTick', 1:3)
    ylabel('Distancia Chi-cuadrado')
    title('Similitud LBP global')

    % Guardar en augmented/
    [~, nombre_base, ~] = fileparts(nombres(i));

    exportgraphics(fig, fullfile(out_path, nombre_base + "_segmentacion.png"), 'Resolution', 150)
    imwrite(uint8(I_otsu1) * 255, fullfile(out_path, nombre_base + "_otsu1.png"))
    imwrite(I_otsu2,              fullfile(out_path, nombre_base + "_otsu2.png"))
    imwrite(I_lbp,                fullfile(out_path, nombre_base + "_lbp.png"))
    imwrite(img_gray, fullfile(out_path, nombre_base + "_grises.png"))

end

fprintf('%s\n', repmat('-', 1, 72))
fprintf('Menor Chi-cuadrado = mayor similitud con esa textura.\n')
fprintf('Resultados guardados en: %s\n', out_path)
