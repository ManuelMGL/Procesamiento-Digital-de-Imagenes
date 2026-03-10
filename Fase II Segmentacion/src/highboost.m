function img_out = highboost(img_in, k)
    f = double(img_in);
    
    w = fspecial('average', [3 3]);
    f_blur = imfilter(f, w, 'replicate');
    
    mask = f - f_blur;

    g = f + k * mask;

    img_out = uint8(max(0, min(255, g)));
end