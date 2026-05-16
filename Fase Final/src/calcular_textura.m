% Ejemplo para construir Hfire


%% Fuego
path_roi = "../examples/roi/";

Htotal = zeros(1,256);
N = 0;

num_images = 25;
name = "fuego";

for i = 1:num_images
    
    full_path = path_roi + "/fuego/" + name + i + ".png";
    
    I = imread(full_path);
    lab = rgb2lab(I);
    L = imgaussfilt(adapthisteq(lab(:,:,1)/100),1);

    lbp = extractLBPFeatures(L);

    H = histcounts(lbp,256);
    H = H / sum(H);

    Htotal = Htotal + H;
    N = N + 1;
end

Hfire = Htotal / N;

save('Hfire.mat','Hfire');


%% Humo
path_roi = "../examples/roi/";

Htotal = zeros(1,256);
N = 0;

num_images = 35;
name = "humo";

for i = 1:num_images
    
    full_path = path_roi + "/humo/" + name + i + ".png";
    
    I = imread(full_path);
    lab = rgb2lab(I);
    L = imgaussfilt(adapthisteq(lab(:,:,1)/100),1);

    lbp = extractLBPFeatures(L);

    H = histcounts(lbp,256);
    H = H / sum(H);

    Htotal = Htotal + H;
    N = N + 1;
end

Hsmoke = Htotal / N;

save('Hsmoke.mat','Hsmoke');
