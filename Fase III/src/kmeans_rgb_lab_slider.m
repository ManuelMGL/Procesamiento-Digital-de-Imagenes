function kmeans_rgb_lab_slider(path)


% =========================
% Imagen
% =========================
img = imread(path);
img = im2double(img);

[H, W, ~] = size(img);

% LAB
img_lab = rgb2lab(img);

% Submuestreo (velocidad)
scale = 0.5;

img_s = imresize(img, scale);
lab_s = imresize(img_lab, scale);

[Hs, Ws, ~] = size(img_s);

X_rgb = reshape(img_s, Hs*Ws, 3);
X_lab = reshape(lab_s, Hs*Ws, 3);

% =========================
% FIGURA (3 columnas)
% =========================
figure('Name','RGB vs LAB K-Means','NumberTitle','off');

% =========================
% ORIGINAL
% =========================
subplot(1,3,1);
imshow(img);
title('Original RGB');

% =========================
% RGB SEG
% =========================
ax_rgb = subplot(1,3,2);
h_rgb = imagesc(zeros(Hs,Ws));
axis image off;
colormap(ax_rgb, lines(10));
title('K-Means RGB');

txt_rgb = uicontrol('Style','text', ...
    'Units','normalized', ...
    'Position',[0.12 0.08 0.25 0.04], ...
    'String','K RGB = 4');

sld_rgb = uicontrol('Style','slider', ...
    'Min',2,'Max',10,'Value',4, ...
    'SliderStep',[1/8 1/8], ... % 1/(Max-Min)
    'Units','normalized', ...
    'Position',[0.10 0.05 0.30 0.03]);

% =========================
% LAB SEG
% =========================
ax_lab = subplot(1,3,3);
h_lab = imagesc(zeros(Hs,Ws));
axis image off;
colormap(ax_lab, lines(10));
title('K-Means LAB');

txt_lab = uicontrol('Style','text', ...
    'Units','normalized', ...
    'Position',[0.62 0.08 0.25 0.04], ...
    'String','K LAB = 4');

sld_lab = uicontrol('Style','slider', ...
    'Min',2,'Max',10,'Value',4, ...
    'SliderStep',[1/8 1/8], ...
    'Units','normalized', ...
    'Position',[0.60 0.05 0.30 0.03]);
% =========================
% CALLBACKS
% =========================
sld_rgb.Callback = @(src,~) updateRGB(round(src.Value));
sld_lab.Callback = @(src,~) updateLAB(round(src.Value));

% inicialización
updateRGB(4);
updateLAB(4);

% =====================================================
% RGB
% =====================================================
function updateRGB(K)

    txt_rgb.String = ['K RGB = ' num2str(K)];

    opts = statset('MaxIter',50);

    idx = kmeans(X_rgb, K, ...
        'Distance','sqeuclidean', ...
        'Replicates',1, ...
        'Options',opts);

    seg = reshape(idx, Hs, Ws);

    h_rgb.CData = imresize(seg,[H W],'nearest');
    colormap(ax_rgb, lines(K));

    drawnow limitrate;
end

% =====================================================
% LAB
% =====================================================
function updateLAB(K)

    txt_lab.String = ['K LAB = ' num2str(K)];

    opts = statset('MaxIter',50);

    idx = kmeans(X_lab, K, ...
        'Distance','sqeuclidean', ...
        'Replicates',1, ...
        'Options',opts);

    seg = reshape(idx, Hs, Ws);

    h_lab.CData = imresize(seg,[H W],'nearest');
    colormap(ax_lab, lines(K));

    drawnow limitrate;
end

end