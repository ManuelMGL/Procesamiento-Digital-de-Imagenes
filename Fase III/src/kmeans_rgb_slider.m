
clc;
clear;
close all;

% =========================
% Imagen
% =========================
nombres = [...
    "1_JPG.rf.82be351019b363a690c1f9394144c4d9.jpg" ...
    "2_png.rf.0120d97dddac35e037d18b09cf507edb.jpg"...
    "32_png.rf.343001e4aa37d963fa0d9942c1192c7b.jpg"...
    "10_png.rf.2bb4801aa63a6070814528d2d7fed3a2.jpg"
    ];

path = "../examples/original/";
new_path = "../examples/";


for i = 1:4
kmeans_rgb_lab_slider(path + nombres(i));

end