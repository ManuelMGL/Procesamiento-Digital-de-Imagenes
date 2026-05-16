function labels = kmeans_lab(image_path, K)

% Lectura de imagen
img = imread(image_path);
img = im2double(img);

% Conversión a LAB
img_lab = rgb2lab(img);

% Dimensiones
[H, W, ~] = size(img_lab);

% Vector de características (L, a, b)
X = reshape(img_lab, H*W, 3);

% K-Means 
opts = statset('MaxIter', 100);

labels = kmeans(X, K, ...
    'Distance', 'sqeuclidean', ...
    'Replicates', 3, ...
    'Options', opts);

% Reorganizar a imagen
labels = reshape(labels, H, W);

end