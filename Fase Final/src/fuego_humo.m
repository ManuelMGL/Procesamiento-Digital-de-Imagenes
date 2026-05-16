clc;
clear;
close all;



path = "../examples/original/";
path_roi = "../examples/roi/";
out_path = "../examples/augmented/";

nombres = [
    "505_jpg.rf.21cffd11c5cbd57e7a6007dd100d0593.jpg"
    "615_jpg.rf.c0a08998591a7f5797259df181fc47b2.jpg"
    "1273_jpg.rf.214759db5a1b3b6b7c477092ddb6738c.jpg"
    "1338_png.rf.fce178cfbccbbf21a4c081c7b5d902f8.jpg"
    "1692_jpg.rf.4023f57d68af59e1d0c25f5002dbb41e.jpg"
    "108_png.rf.ddda45ea75a7ebf59c9401a851942dd7.jpg"
    "160_png.rf.c93be23cb2879429af26cab1d5a47dc5.jpg"
    "170_png.rf.22beb8e9b00508e8c0c2a0bd3d84966b.jpg"
    "206_png.rf.9ccaf8774dc16f43474841f7cc0b0d77.jpg"
    "387_jpg.rf.3f62c057403543d28c831bdd0b5d754c.jpg"
    "364_png.rf.154a21331ac5c7149de0795aa510b99e.jpg"
    "392_png.rf.d1f34dc23caddab8308e3aab6a6cba3e.jpg"
    ];


% 1. Leer imagen
full_path  = path + nombres(7);
% 2 3, 4, 5

fire_smoke(full_path)