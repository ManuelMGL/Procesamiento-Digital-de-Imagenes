close all force
clc
clear all


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

% Lectura de la imagen
I = I3;

% Aplicación de ruido a la imagen original
N{1} = imnoise(I, 'gaussian', 0.03, 0.01);
N{2} = imnoise(I, 'gaussian', 0.0003, 0.1); %media = 0.03 varianza = 0.01
N{3} = imnoise(I, 'salt & pepper');

N{1} = I;

randaux = rand(size(I));
J = I;

J(randaux>0.9) = 255;
N{4} = J;


% Mostrar imagen original vs. imágenes con ruido

figure
tiledlayout(2,2,'Padding','compact','TileSpacing','compact')
nexttile; imshow(I,[]); title('Imagen original');
nexttile; imshow(N{1},[]); title('Salt & Pepper');
nexttile; imshow(N{2},[]); title('Gaussian');
nexttile; imshow(N{3},[]); title('Poisson');

titles = {'Imagen Original', 'Gaussian', 'Gaussian'};
title_filters = {'Imagen filtrada con AMF', 'Adaptativo', 'Adaptativo', 'Adaptativo', 'Punto Medio', 'Promedio'};
filtros = ["med", "max", "min", "pntmed", "prom"];

factores = [1, 2, 5, 10, 50];

% Filtros con máscara dinámica
figure
title("Filtro adaptativo de mediana")

R = 4;
S = 4;
G_i = 1;

% tiledlayout(R, S,'Padding','compact','TileSpacing','compact')
% nexttile; imshow(N{G_i}, []); title("salt and pepper");
% 
% for filter = 1:R*S-1
%         masc_size = filter*2 + 1;
%         F_3x3{filter} = adaptive_filter_median(N{G_i}, masc_size);
%         nexttile; imshow(F_3x3{filter}, []); title("A. Median, masc. max.: " + masc_size);
% end
% 
% % Límite de máscara a 9
% figure
% title("Filtro adaptativo de mediana")
% 
R = 2;
S = 2;
G_i = 1;

tiledlayout(R, S,'Padding','compact','TileSpacing','compact')
nexttile; imshow(N{G_i}, []); title("Imagen Original");

for filter = 1:R*S-1
        masc_size = filter*2 + 1;
        F_3x3{filter} = adaptive_filter_median(N{G_i}, masc_size);
        nexttile; imshow(F_3x3{filter}, []); title("A. Median, masc. max.: " + masc_size);
end

