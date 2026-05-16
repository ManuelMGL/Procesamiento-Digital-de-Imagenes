function labels = kmeans_rgb(image_path, K)

% Lectura de imagen
img = imread(image_path);
img = im2double(img);

% Dimensiones
[H, W, ~] = size(img);

% RGB puro a vector
X = reshape(img, H*W, 3);

% K-Means 
opts = statset('MaxIter', 100);

labels = kmeans(X, K, ...
    'Distance', 'sqeuclidean', ...
    'Replicates', 3, ...
    'Options', opts);

% Reorganizar a imagen
labels = reshape(labels, H, W);

end