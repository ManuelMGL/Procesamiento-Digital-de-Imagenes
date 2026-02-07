% Aumento de datos
clc
clear all
close all force

nombres = [...
    "1_JPG.rf.82be351019b363a690c1f9394144c4d9.jpg" ...
    "30_png.rf.6cbeb530234c3ab68177111a4b97f767.jpg"...
    "98_png.rf.72cc9d6f4481c6d509a464692b7da029.jpg"...
    "173_JPG.rf.3d77dde3b3a5641f2b17638b3c40b8e3.jpg"...
    "264_png.rf.43a917f94cc73493b26b63d01e015184.jpg"
    ];

path = "../examples/original/";
new_path = "../examples/";


I1 = imread(path + nombres(1));
I2 = imread(path + nombres(2));
I3 = imread(path + nombres(3));
I4 = imread(path + nombres(4));
I5 = imread(path + nombres(5));

% Convertir la imagen a escala de grises
I1 = im2gray(I1);
I2 = im2gray(I2);
I3 = im2gray(I3);
I4 = im2gray(I4);
I5 = im2gray(I5);

I = {I1, I2, I3, I4, I5};

volteados = {[0, 1], [1, 0], [1, 1], [0, 1], [1, 1]};
angulos = {30, 45, 60, 80, 90};
traslaciones = {[200, 300], [400, 500], [300, 400], [100, 100], [50, 400]};
escalados = {[2, 3], [4, 5], [3, 4], [10, 10], [5, 4]};


% a. Volteado (flipping)
% b. Rotación aplicando interpolación bilineal para definir la intensidad de la imagen resultante.
% c. Traslación
% d. Escalamiento aplicando interpolación bilineal para definir la intensidad de la imagen resultante.
% e. Borrado aleatorio (Random erase)
% f. Mezclado de regiones (cutmix)

for i = 1:5
    
    % a.  Volteado (flipping)
    I_flipping = flipping(I{i}, volteados{i}(1), volteados{i}(2));
    
    % b. Rotación aplicando interpolación bilineal para definir la intensidad de la imagen resultante.
    ang = 30;
    I_rotation = rotacionBilineal(I{i}, angulos{i});
    
    % c.  Traslación
    I_traslation = traslation(I{i}, traslaciones{i}(1), traslaciones{i}(2));
    
    % d.  Escalamiento aplicando interpolación bilineal para definir la intensidad de la imagen resultante.
    I_escalado = escalaBilineal(I{i}, escalados{i}(1), escalados{i}(2));
    
    % e.  Borrado aleatorio (Random erase)
    I_borradoAleatorio = randomErase(I{i}, 0.9, 0);
    
    % f. Mezclado de regiones (cutmix)
    I_cutmix = cutMix(I{i}, I{3}, 0.9);
    
        figure;
    
        subplot(3, 3, 2)
        imshow(I{i}, [])
        title('Imagen Original')
    
        subplot(3, 3, 4)
        imshow(I_flipping, [])
        title('Flipping')
    
        subplot(3, 3, 5)
        imshow(I_rotation, [])
        title('Rotación Bilineal')
    
        subplot(3, 3, 6)
        imshow(I_traslation, [])
        title('Traslación')
    
        subplot(3, 3, 7)
        imshow(I_escalado, [])
        title('Escala Bilineal')
    
        subplot(3, 3, 8)
        imshow(I_borradoAleatorio, [])
        title('Random Erase')
    
        subplot(3, 3, 9)
        imshow(I_cutmix, [])
        title('CutMix')
    
    outDir = fullfile(new_path, "augmented");
    
    if ~exist(outDir, 'dir')
        mkdir(outDir)
    end
    
    [~, name, ~] = fileparts(nombres(i));
    
    imwrite(uint8(I{i}), fullfile(outDir, name + "_grises" + ".jpg"));    
    imwrite(uint8(I_flipping), fullfile(outDir, name + "_flipping" + ".jpg"));
    imwrite(uint8(I_rotation), fullfile(outDir, name + "_rotacion" + ".jpg"));
    imwrite(uint8(I_traslation), fullfile(outDir, name + "_traslacion" + ".jpg"));
    imwrite(uint8(I_escalado), fullfile(outDir, name + "_escala_bilineal" + ".jpg"));
    imwrite(uint8(I_borradoAleatorio), fullfile(outDir, name + "_borrado_aleatorio" + ".jpg"));
    imwrite(uint8(I_cutmix), fullfile(outDir, name + "_cutmix" + ".jpg"));

       
    
end
