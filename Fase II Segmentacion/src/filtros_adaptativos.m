close all force
clc
clear all

% Lectura de la imagen
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

Imgs = {I1, I2, I3, I4, I5};

I = I5;

% Aplicación de ruido a la imagen original
N{1} = imnoise(I, 'salt & pepper', 0.03);
N{2} = imnoise(I, 'gaussian', 0.03, 0.01); %media = 0.03 varianza = 0.01
N{3} = imnoise(I, 'poisson');

N{1} = I;

randaux = rand(size(I));
J = I;

J(randaux>0.9) = 255;


% Mostrar imagen original vs. imágenes con ruido

figure
tiledlayout(2,2,'Padding','compact','TileSpacing','compact')
nexttile; imshow(I,[]); title('Imagen original');
nexttile; imshow(N{1},[]); title('Salt & Pepper');
nexttile; imshow(N{2},[]); title('Gaussian');
nexttile; imshow(N{3},[]); title('Poisson');

titles = {'Imagen Original', 'Gaussian', 'Poisson'};
title_filters = {'Adaptativo Local', 'Mediana', 'Máximo', 'Mínimo', 'Punto Medio', 'Promedio'};
filtros = ["med", "max", "min", "pntmed", "prom"];


% Filtros con máscara 3x3
size_masc = 7;
figure
title("Filtros 3x3")
tiledlayout(3, 2,'Padding','compact','TileSpacing','compact')

masc_size = 5;
for noise = 1:3
    nexttile; imshow(N{noise}, []); title(titles{noise});
    
    for filter = 1:1
        F_3x3{noise, filter} = adaptive_filter(N{noise}, masc_size, 1);
        
        nexttile; imshow(F_3x3{noise, filter}, []); title(title_filters{filter});
    end
end