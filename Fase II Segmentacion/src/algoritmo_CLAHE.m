% Algoritmo de CLAHE
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

img = I1;


[M, N] =  size(img);

M2 = M/2;
N2 = N/2;

% Dividimos la imagen en 4 partes
part1 = img(1:M2, 1:N2);
part2 = img(M2+1:end, 1:N2);
part3 = img(1:M2, N2+1:end);
part4 = img(M2+1:end, N2+1:end);

% Llamámos a la funcion J = ecualizar(I)
J1 = ecualizar(part1);
J2 = ecualizar(part2);
J3 = ecualizar(part3);
J4 = ecualizar(part4);

cl1 = 250;
cl2 = 250;
cl3 = 250;
cl4 = 250;

[J1_new, T1] = cliplim(J1, cl1);
[J2_new, T2] = cliplim(J2, cl2);
[J3_new, T3] = cliplim(J3, cl3);
[J4_new, T4] = cliplim(J4, cl4);


im2 = [J1_new J3_new; J2_new J4_new];


J1_new = interpola_tile(part1, T1, T3, T2, T4);
J2_new = interpola_tile(part2, T1, T3, T2, T4);
J3_new = interpola_tile(part3, T1, T3, T2, T4);
J4_new = interpola_tile(part4, T1, T3, T2, T4);

% im2 = [J1 J3; J2 J4];
im2_new = [J1_new J3_new; J2_new J4_new];

% Graficamos la imagen original, su histograma, la imagen resultante y el
% histograma de este
figure
subplot(4, 4, 1)
imshow(part1)
subplot(4, 4, 2)
histogram(part1)
subplot(4, 4, 3)
imshow(J1, [])
subplot(4, 4, 4)
histogram(J1)

subplot(4, 4, 5)
imshow(part2)
subplot(4, 4, 6)
histogram(part2)
subplot(4, 4, 7)
imshow(J2, [])
subplot(4, 4, 8)
histogram(J2)

subplot(4, 4, 9)
imshow(part3)
subplot(4, 4, 10)
histogram(part3)
subplot(4, 4, 11)
imshow(J3, [])
subplot(4, 4, 12)
histogram(J3)

subplot(4, 4, 13)
imshow(part4)
subplot(4, 4, 14)
histogram(part4)
subplot(4, 4, 15)
imshow(J4, [])
subplot(4, 4, 16)
histogram(J4)


figure
subplot(4, 4, 1)
imshow(J1)
subplot(4, 4, 2)
histogram(J1)
subplot(4, 4, 3)
imshow(J1_new, [])
subplot(4, 4, 4)
histogram(J1_new)

subplot(4, 4, 5)
imshow(J2)
subplot(4, 4, 6)
histogram(J2)
subplot(4, 4, 7)
imshow(J2_new, [])
subplot(4, 4, 8)
histogram(J2_new)

subplot(4, 4, 9)
imshow(J3)
subplot(4, 4, 10)
histogram(J3)
subplot(4, 4, 11)
imshow(J3_new, [])
subplot(4, 4, 12)
histogram(J3_new)

subplot(4, 4, 13)
imshow(J4)
subplot(4, 4, 14)
histogram(J4)
subplot(4, 4, 15)
imshow(J4_new, [])
subplot(4, 4, 16)
histogram(J4_new)


figure
subplot(1, 3, 1)
imshow(img, [])
title("Imagen Original")

subplot(1, 3, 2)
imshow(im2, [])
title("Imagen Ecualizada usando A-CLAHE")

subplot(1, 3, 3)
imshow(im2_new, [])
title("Imagen Ecualizada con Interpolacion")

figure
subplot(2, 2, 1)
imshow(J1_new)

subplot(2, 2, 2)
imshow(J3_new)

subplot(2, 2, 3)
imshow(J2_new)

subplot(2, 2, 4)
imshow(J4_new)

[nk1n, rk1n] = imhist(J1_new);
[nk2n, rk2n] = imhist(J2_new);
[nk3n, rk3n] = imhist(J3_new);
[nk4n, rk4n] = imhist(J4_new);


figure
subplot(2, 2, 1)
plot(nk1n)
subplot(2, 2, 2)
plot(nk3n)
subplot(2, 2, 3)
plot(nk2n)
subplot(2, 2, 4)
plot(nk4n)











